#!/usr/bin/env python3
"""Extract the bexio API documentation snapshot into Markdown reference + OpenAPI spec.

bexio does not publish an OpenAPI/Swagger definition (their FAQ explicitly says so),
so this script reconstructs one from a saved single-page snapshot (MHTML) of
https://docs.bexio.com/.

Usage:
    python3 scripts/extract_bexio_api_docs.py [--mhtml PATH] [--out-dir docs]

Outputs (default under docs/):
    reference/           Markdown reference (one file per API group + info pages)
    reference/operations.json   machine-readable operation index
    bexio-openapi.json   reconstructed OpenAPI 3.0 spec (unofficial)
    bexio-openapi.yaml   same spec as YAML

The snapshot must be saved with "save page as MHTML" (e.g. Blink/Chrome) from
https://docs.bexio.com/ with all sections expanded. Re-run this script whenever
a fresh snapshot is saved to see what changed in the docs.
"""
import argparse
import datetime
import email
import email.policy
import html as htmllib
import json
import os
import re
import sys
from collections import OrderedDict
from html.parser import HTMLParser

# The docs are fetched from the live site by default; see --source for using
# a saved HTML file or an MHTML snapshot instead.

SKIP_TAGS = {"script", "style", "svg", "noscript"}
VOID = {"br", "hr", "img", "meta", "link", "input", "polygon", "path", "circle"}


class Node:
    __slots__ = ("tag", "attrs", "children", "text", "parent")

    def __init__(self, tag, attrs, parent=None):
        self.tag, self.attrs, self.parent = tag, dict(attrs), parent
        self.children = []
        self.text = ""

    def cls(self):
        return self.attrs.get("class", "")


class DocParser(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.root = Node("root", {})
        self.stack = [self.root]

    def handle_starttag(self, tag, attrs):
        if tag in SKIP_TAGS:
            self.stack.append(None)
            return
        top = self.stack[-1]
        n = Node(tag, attrs, top)
        if top is not None:
            top.children.append(n)
        if tag not in VOID:
            self.stack.append(n)

    def handle_startendtag(self, tag, attrs):
        if tag in SKIP_TAGS or self.stack[-1] is None:
            return
        n = Node(tag, attrs, self.stack[-1])
        self.stack[-1].children.append(n)

    def handle_endtag(self, tag):
        if tag in SKIP_TAGS:
            while len(self.stack) > 1 and self.stack.pop() is None:
                pass
            return
        if tag in VOID:
            return
        for i in range(len(self.stack) - 1, 0, -1):
            if self.stack[i] and self.stack[i].tag == tag:
                del self.stack[i:]
                break

    def handle_data(self, data):
        if not self.stack or not data:
            return
        top = self.stack[-1]
        if top is not None:
            t = Node("#text", {}, top)
            t.text = data
            top.children.append(t)


# ---------------------------------------------------------------- tree helpers

def parse_html(html_text):
    p = DocParser()
    p.feed(html_text)
    return p.root


def all_nodes(root):
    out = []

    def walk(n):
        for c in n.children:
            out.append(c)
            walk(c)

    walk(root)
    return out


def find_all(node, pred, out=None):
    if out is None:
        out = []
    for c in node.children:
        if pred(c):
            out.append(c)
        find_all(c, pred, out)
    return out


def find_first(node, pred):
    r = find_all(node, pred)
    return r[0] if r else None


def text_of(node):
    parts = []

    def walk(n):
        if n.tag == "#text":
            if n.text.strip():
                parts.append(n.text.strip())
            return
        for c in n.children:
            walk(c)

    walk(node)
    return re.sub(r"\s+", " ", " ".join(parts)).strip()


def desc_md(node):
    """Div with html= attribute containing escaped description HTML -> markdown text."""
    raw = node.attrs.get("html")
    if raw is None:
        return text_of(node)
    raw = htmllib.unescape(raw)
    raw = re.sub(r"<(code|pre)[^>]*>", "`", raw)
    raw = re.sub(r"</(code|pre)>", "`", raw)
    raw = re.sub(r"<li[^>]*>", "\n- ", raw)
    raw = re.sub(r"<(p|div|br|ul|ol|tr|h[1-6])[^>]*/?>", "\n", raw)
    raw = re.sub(r"<[^>]+>", "", raw)
    raw = htmllib.unescape(raw)
    lines = [re.sub(r"\s+", " ", l).strip() for l in raw.split("\n")]
    return "\n".join(l for l in lines if l).strip()


def pre_block(pre):
    out = []

    def render(n):
        if n.tag in ("button", "svg"):
            return
        if n.tag == "#text":
            out.append(n.text)
            return
        for c in n.children:
            render(c)

    render(pre)
    return re.sub(r"\n\s*\n", "\n", "".join(out)).strip()


# ------------------------------------------------------------- schema parsing

BASIC_TYPES = {"string": "string", "integer": "integer", "number": "number",
               "boolean": "boolean", "date": "string", "object": "object"}


def cell_tokens(val_cell):
    """Ordered (kind, text) tokens of a schema table value cell; descriptions excluded."""
    tokens = []

    def collect(n):
        if n.tag == "#text":
            tokens.append(("text", n.text))
            return
        if "property-name" in n.cls():
            return
        if n.attrs.get("html") is not None:
            return  # description div
        if n.text:
            tokens.append(("text", n.text))
        for c in n.children:
            collect(c)

    collect(val_cell)
    return tokens


def parse_type(tokens):
    """Parse type tokens into an (incomplete) OpenAPI schema fragment."""
    raw = re.sub(r"\s+", " ", "".join(t for _, t in tokens)).strip()
    s = {"type": None}
    m = re.match(
        r"^(?:Array of )?(object|objects|string|integer|number|boolean|strings|date|date-time)\b",
        raw,
    )
    one_of = None
    if not m:
        # oneOf renderings, e.g. "Array of PositionCustom (object) or PositionArticle (object)"
        names = re.findall(r"([A-Za-z][\w]*)\s*\(object\)", raw)
        if names:
            one_of = names
            if raw.startswith("Array of "):
                s["type"] = "array"
                s["items"] = {"type": "object", "x-schema-names": names}
            else:
                s["type"] = "object"
                s["x-one-of"] = names
            rest = raw
        else:
            rest = raw
    else:
        t = m.group(1)
        if t == "objects":
            s.update(type="array", items={"type": "object"})
        elif t == "strings":
            s.update(type="array", items={"type": "string"})
        elif t == "date":
            s.update(type="string", format="date")
        elif t == "date-time":
            s.update(type="string", format="date-time")
        else:
            s["type"] = t
        rest = raw[m.end():]
    if " or null" in raw:
        s["nullable"] = True
    fm = re.search(r"<(int32|int64|float|double|date|date-time|byte|binary)>", rest)
    if fm:
        s.setdefault("format", fm.group(1))
        if s.get("type") is None:
            s["type"] = "string"
    dm = re.search(r'Default:\s*("[^"]*"|[^\s]+)', rest)
    if dm:
        d = dm.group(1).strip('"')
        if s.get("type") == "integer" and re.fullmatch(r"-?\d+", d):
            d = int(d)
        elif s.get("type") == "number" and re.fullmatch(r"-?\d+(\.\d+)?", d):
            d = float(d)
        elif s.get("type") == "boolean" and d in ("true", "false"):
            d = d == "true"
        s["default"] = d
    em = re.search(r"Enum:\s*(\"[^\"]*\"(?:\s+\"[^\"]*\")*|[\w.]+(?:\s+[\w.]+)*)", rest)
    if em:
        vals = re.findall(r'"([^"]*)"|([-\w.]+)', em.group(1))
        enum = [a or b for a, b in vals]
        if s.get("type") == "integer":
            enum = [int(e) for e in enum if re.fullmatch(r"-?\d+", e)]
        if enum:
            s["enum"] = enum
    rm = re.search(r"\[\s*(\d+)\s*\.\.\s*(\d+|\u221e|\*)\s*\]", raw)
    if rm and s.get("type") == "array":
        if rm.group(1) != "0":
            s["minItems"] = int(rm.group(1))
        mx = rm.group(2)
        if mx not in ("\u221e", "*"):
            s["maxItems"] = int(mx)
    if s["type"] is None:
        s["type"] = "string"
    return s, raw


def parse_schema_table(tbl):
    """Parse a Redoc schema/parameter table into ordered row dicts with depth."""
    rows = []
    for tr in find_all(tbl, lambda n: n.tag == "tr"):
        tds = find_all(tr, lambda n: n.tag == "td")
        if not tds:
            continue
        name_cell, val_cell = tds[0], (tds[1] if len(tds) > 1 else None)
        pname = find_first(name_cell, lambda n: "property-name" in n.cls())
        if pname is None:
            continue  # enum-value sub-row (redundant: Enum: is part of the parent row text)
        name = text_of(pname)
        deprecated = " deprecated" in name_cell.cls()
        required = any(text_of(d) == "required" for d in find_all(name_cell, lambda n: n.tag == "div"))
        # NOTE: rows carrying the expandable-marker class are *top-level* properties whose
        # nested child rows are collapsed (not rendered) in the snapshot. Depth is always 0.
        depth = 0
        desc = ""
        if val_cell is not None:
            for d in find_all(val_cell, lambda n: n.attrs.get("html")):
                t = desc_md(d)
                if t:
                    desc = t
        tokens = cell_tokens(val_cell) if val_cell is not None else []
        schema, raw = parse_type(tokens)
        rows.append({
            "name": name, "depth": depth, "required": required,
            "deprecated": deprecated, "schema": schema, "description": desc,
            "raw": raw,
        })
    return rows


def tables_after(node, marker):
    """All `table` descendants of node that appear after `marker` in document order."""
    order = {id(n): i for i, n in enumerate(all_nodes(node))}
    start = order.get(id(marker))
    if start is None:
        return find_all(node, lambda n: n.tag == "table")
    return [t for t in find_all(node, lambda n: n.tag == "table") if order.get(id(t), -1) > start]


def rows_to_schema(rows, top_array=False):
    """Build an OpenAPI schema object from parsed rows (max 2 levels of nesting)."""
    top = rows[0] if rows else None
    # body-level array?
    if top_array or (top and top["schema"].get("type") == "array" and top["depth"] == 0
                     and not any(r["depth"] == 0 for r in rows[1:])):
        item_rows = [r for r in rows[1:] if r["depth"] >= 0]
        items = rows_to_schema(item_rows) if item_rows else {"type": "object"}
        s = dict(top["schema"]) if top else {"type": "array"}
        s["items"] = items
        return s

    obj = {"type": "object", "properties": OrderedDict(), "required": []}
    i = 0
    while i < len(rows):
        r = rows[i]
        if r["depth"] != 0:
            i += 1
            continue
        schema = dict(r["schema"])
        if r["description"]:
            schema["description"] = r["description"]
        if r["deprecated"]:
            schema["deprecated"] = True
        # gather children
        children = []
        j = i + 1
        while j < len(rows) and rows[j]["depth"] > 0:
            children.append(rows[j])
            j += 1
        if children:
            inner = children[0]["schema"]
            if inner.get("type") == "array":
                # nested object rows define the item schema
                sub = rows_to_schema([dict(c, depth=c["depth"] - 1) for c in children[1:]])
                if sub.get("type") == "object" and sub.get("properties"):
                    inner["items"] = sub
                schema.update({k: v for k, v in inner.items() if k not in ("description",)})
            elif inner.get("type") == "object":
                sub = rows_to_schema([dict(c, depth=c["depth"] - 1) for c in children[1:]])
                schema["properties"] = sub.get("properties", {})
                schema["required"] = sub.get("required", [])
        obj["properties"][r["name"]] = schema
        if r["required"]:
            obj["required"].append(r["name"])
        i = j
    if not obj["required"]:
        del obj["required"]
    return obj


def rows_to_params(tbl, location):
    params = []
    for r in parse_schema_table(tbl):
        p = {"name": r["name"], "in": location, "schema": r["schema"]}
        if r["required"]:
            p["required"] = True
        if r["description"]:
            p["description"] = r["description"]
        if r["deprecated"]:
            p["deprecated"] = True
        params.append(p)
    return params


# ---------------------------------------------------------------- md helpers

def md_param_table(rows):
    lines = ["| Parameter | Type | Description |", "|---|---|---|"]
    for r in rows:
        name = r["name"]
        if r["depth"]:
            name = "↳ " + name
        if r["required"]:
            name += " *(required)*"
        if r["deprecated"]:
            name += " *(deprecated)*"
        typ = r["raw"] or json.dumps(r["schema"])
        cells = [c.replace("|", "\\|").replace("\n", " ") for c in (name, typ, r["description"])]
        lines.append("| " + " | ".join(cells) + " |")
    return "\n".join(lines)


def json_from_redoc(node):
    """Reconstruct JSON from a redoc-json sample block (collapsible but complete)."""
    out = []

    def walk(n, depth):
        for c in n.children:
            if c.tag == "button" or "ellipsis" in c.cls():
                continue
            if c.tag == "ul":
                for li in c.children:
                    if li.tag != "li":
                        continue
                    out.append("\n" + "  " * (depth + 1))
                    walk(li, depth + 1)
                out.append("\n" + "  " * depth)
            else:
                if c.tag == "#text":
                    out.append(c.text)
                walk(c, depth)

    code = find_first(node, lambda n: n.tag == "code") or node
    walk(code, 0)
    raw = "".join(out).strip()
    raw = re.sub(r",\s*([}\]])", r"\1", raw)
    try:
        return json.loads(raw)
    except Exception:
        return None


# ---------------------------------------------------------------- YAML output

def to_yaml(obj, indent=0):
    pad = "  " * indent
    if obj is None:
        return "null"
    if isinstance(obj, bool):
        return "true" if obj else "false"
    if isinstance(obj, (int, float)):
        return str(obj)
    if isinstance(obj, str):
        if obj == "" or re.search(r"[:#\-\n{}[\],&*?|>'\"%@`]", obj) or obj != obj.strip() \
                or obj.lower() in ("true", "false", "null", "yes", "no", "on", "off", "~") \
                or re.fullmatch(r"[-+]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?", obj) \
                or re.fullmatch(r"0[xXoObB][\da-fA-F]+", obj) \
                or re.fullmatch(r"[-\w./ ]+", obj) is None:
            return json.dumps(obj)
        return obj
    if isinstance(obj, list):
        if not obj:
            return "[]"
        lines = []
        for v in obj:
            if isinstance(v, (dict, list)) and v:
                block = to_yaml(v, indent + 1)
                first, _, rest = block.partition("\n")
                lines.append(f"{pad}- {first[len(pad) + 2:]}")
                if rest:
                    lines.append(rest)
            else:
                lines.append(f"{pad}- {to_yaml(v, indent + 1)}")
        return "\n".join(lines)
    if isinstance(obj, dict):
        if not obj:
            return "{}"
        lines = []
        for k, v in obj.items():
            key = k if re.fullmatch(r"[\w.\-]+", k) else json.dumps(k)
            if isinstance(v, (dict, list)) and v:
                lines.append(f"{pad}{key}:")
                lines.append(to_yaml(v, indent + 1))
            else:
                lines.append(f"{pad}{key}: {to_yaml(v, indent + 1)}")
        return "\n".join(lines)
    raise TypeError(repr(obj))


# ---------------------------------------------------------------- extraction

DEFAULT_URL = "https://docs.bexio.com/"


def load_source(source):
    """Load the docs from a URL, a raw HTML file or an MHTML snapshot file.

    Returns (html_text, snapshot_date). The date is the HTTP Last-Modified
    header (URL), the MHTML Date header (snapshot) or today (raw file).
    """
    if re.match(r"^https?://", source):
        import urllib.request
        req = urllib.request.Request(source, headers={"User-Agent": "bexio-api-docs-extractor/1.0"})
        with urllib.request.urlopen(req, timeout=120) as resp:
            data = resp.read()
            last_modified = resp.headers.get("Last-Modified", "")
        snapshot_date = last_modified or datetime.date.today().isoformat()
        return data.decode("utf-8", "replace"), snapshot_date

    with open(source, "rb") as f:
        data = f.read()
    head = data[:200].lstrip()
    if head.startswith(b"From:") or b"multipart/related" in data[:2000]:
        msg = email.message_from_bytes(data, policy=email.policy.default)
        part = next(p for p in msg.walk() if p.get_content_type() == "text/html")
        return part.get_payload(decode=True).decode("utf-8", "replace"), str(msg.get("Date", "")).strip()
    return data.decode("utf-8", "replace"), datetime.date.today().isoformat()


def extract(html_text):
    root = parse_html(html_text)
    nodes = all_nodes(root)

    # sidebar: data-item-id -> top-level group title
    group_of = {}

    def walk_sidebar(node, current=None):
        if node.tag == "li" and "data-item-id" in node.attrs:
            item_id = node.attrs["data-item-id"]
            if item_id.startswith("group/"):
                label = find_first(node, lambda n: n.tag == "label")
                span = find_first(label, lambda n: n.tag == "span") if label else None
                t = text_of(span) if span else text_of(node)
                if t:
                    current = t
            if current:
                group_of[item_id] = current
            for c in node.children:
                walk_sidebar(c, current)
            return
        for c in node.children:
            walk_sidebar(c, current)

    walk_sidebar(root)

    # suffix -> top-level group (sidebar item ids may be tag-prefixed)
    op_group = {}
    for item_id, grp in group_of.items():
        m = re.search(r"operation/(.+)$", item_id)
        if m:
            op_group[m.group(1)] = grp

    sections, seen = [], set()
    for n in nodes:
        if n.tag == "div" and "data-section-id" in n.attrs:
            sid = n.attrs["data-section-id"]
            if sid not in seen:
                seen.add(sid)
                sections.append(n)

    ops, pages = [], []
    last_tag = None
    op_suffixes = set()
    for s in sections:
        sid = s.attrs["data-section-id"]
        if sid.startswith("group/"):
            continue
        if sid.startswith("tag/") and "/operation/" not in sid:
            h = find_first(s, lambda n: n.tag in ("h1", "h2", "h3"))
            t = text_of(h) if h else None
            if t:
                last_tag = t
            continue
        if sid.startswith("section/"):
            h = find_first(s, lambda n: n.tag in ("h1", "h2", "h3"))
            title = text_of(h or s)
            body = desc_md(find_first(s, lambda n: n.attrs.get("html")) or s)
            pages.append((sid, title, body))
            continue
        if "operation" in sid:
            op_suffix = re.sub(r"^(tag/[^/]+/)?operation/", "", sid)
            if op_suffix in op_suffixes:
                continue
            op_suffixes.add(op_suffix)
            op_id = op_suffix
            h2 = find_first(s, lambda n: n.tag == "h2")
            verb_span = find_first(s, lambda n: "http-verb" in n.cls())
            verb = verb_span.attrs.get("type", "?") if verb_span else "?"
            path = "?"
            if verb_span is not None and len(verb_span.parent.children) > 1:
                path = text_of(verb_span.parent.children[1])
            grp = last_tag
            auth = []
            for h5 in find_all(s, lambda n: n.tag == "h5"):
                if text_of(h5) == "Authorizations:":
                    auth = [text_of(i) for i in find_all(h5.parent, lambda n: n.tag == "i")]
            op = {
                "operationId": op_id, "group": grp,
                "top_group": op_group.get(op_id, grp), "method": verb, "path": path,
                "title": text_of(h2) if h2 else op_id,
                "auth": auth, "node": s,
            }
            ops.append(op)
    return ops, pages, group_of


def parse_operation(op):
    """Extract markdown block + structured OpenAPI pieces from an operation section."""
    s = op["node"]
    h2 = find_first(s, lambda n: n.tag == "h2")
    verb, path, op_id = op["method"], op["path"], op["operationId"]
    desc = ""
    for d in find_all(s, lambda x: x.attrs.get("html")):
        t = desc_md(d)
        if t:
            desc = t
            break

    parameters, body_schema, body_required, body_ctype = [], None, False, "application/json"
    for h5 in find_all(s, lambda n: n.tag == "h5"):
        label = text_of(h5)
        sibs = h5.parent.children
        idx = sibs.index(h5)
        tbl = next((c for c in sibs[idx + 1:] if c.tag == "table"), None)
        if tbl is None:
            after = tables_after(h5.parent, h5)
            tbl = after[0] if after else None
        if label == "Authorizations:":
            continue
        if label.startswith("Request Body schema"):
            m = re.search(r"schema:\s*(\S+)", label)
            if m:
                body_ctype = m.group(1)
            if "required" in label.split():
                body_required = True
            if tbl:
                rows = parse_schema_table(tbl)
                # body may itself be an array (e.g. bulk create)
                first = rows[0]["schema"] if rows else {"type": "object"}
                is_array_body = first.get("type") == "array" and not any(
                    r["depth"] == 0 and r["schema"].get("type") != "array" for r in rows[1:])
                body_schema = rows_to_schema(rows, top_array=is_array_body)
        elif "Parameters" in label and tbl:
            loc = "path" if label.startswith("path") else \
                  "query" if label.startswith("query") else "header"
            for p in rows_to_params(tbl, loc):
                if p["in"] == "header" and p["name"].lower() in ("accept", "authorization", "content-type"):
                    continue
                parameters.append(p)

    responses = OrderedDict()
    for h3 in find_all(s, lambda n: n.tag == "h3"):
        label = text_of(h3)
        if label == "Responses":
            for strong in find_all(h3.parent, lambda n: n.tag == "strong"):
                code = text_of(strong).split()[0]
                d = None
                sib = strong
                while d is None and sib is not None:
                    sibs = sib.parent.children
                    idx = sibs.index(sib)
                    d = next((c for c in sibs[idx + 1:] if c.attrs.get("html")), False)
                    sib = sib.parent
                responses.setdefault(code, {"description": desc_md(d) if d else ""})
        elif "Response samples" in label:
            panels = find_all(h3.parent, lambda n: "react-tabs__tab-panel" in n.cls())
            tabs = [text_of(t) for t in find_all(h3.parent, lambda n: n.tag == "li" and "react-tabs__tab" in n.cls())]
            for pi, panel in enumerate(panels):
                code = tabs[pi] if pi < len(tabs) else None
                json_div = find_first(panel, lambda n: "redoc-json" in n.cls())
                if json_div:
                    sample = json_from_redoc(json_div)
                    if sample is not None and code and code in responses:
                        responses[code].setdefault("content", {})["application/json"] = {"example": sample}

    request_sample = None
    for h3 in find_all(s, lambda n: n.tag == "h3" and "Request samples" in text_of(n)):
        panels = find_all(h3.parent, lambda n: "react-tabs__tab-panel" in n.cls())
        for panel in panels:
            json_div = find_first(panel, lambda n: "redoc-json" in n.cls())
            if json_div:
                sample = json_from_redoc(json_div)
                if sample is not None:
                    request_sample = sample
                    break

    op.update({
        "description": desc, "parameters": parameters, "body_schema": body_schema,
        "body_required": body_required, "body_ctype": body_ctype,
        "responses": responses, "request_sample": request_sample,
    })
    return op


def build_markdown_block(op):
    lines = [f"## `{op['method'].upper()}` `{op['path']}` — {op['title']}", "",
             f"operationId: `{op['operationId']}`", ""]
    if op["description"]:
        lines += [op["description"], ""]
    if op["auth"]:
        lines += [f"### Authorizations", ", ".join(op["auth"]), ""]
    loc_labels = {"path": "path Parameters", "query": "query Parameters", "header": "header Parameters"}
    for loc in ("path", "query", "header"):
        ps = [p for p in op["parameters"] if p["in"] == loc]
        if ps:
            rows = [{"name": p["name"], "depth": 0, "required": p.get("required", False),
                     "deprecated": p.get("deprecated", False), "schema": p["schema"],
                     "description": p.get("description", ""), "raw": raw_type(p["schema"])} for p in ps]
            lines += [f"### {loc_labels[loc]}", "", md_param_table(rows), ""]
    if op["body_schema"] is not None:
        rows = schema_to_md_rows(op["body_schema"])
        lines += [f"### Request Body schema: {op['body_ctype']}" +
                  (" *(required)*" if op["body_required"] else ""), "", md_param_table(rows), ""]
    codes = ", ".join(op["responses"].keys()) or "_none_"
    lines += ["### Responses", "", codes, ""]
    for code, r in op["responses"].items():
        desc = r.get("description", "")
        if desc:
            lines += [f"**{code}** — {desc}", ""]
        ex = r.get("content", {}).get("application/json", {}).get("example")
        if ex is not None:
            lines += [f"**Response samples** ({code}):", "", "```json",
                      json.dumps(ex, indent=2), "```", ""]
    if op["request_sample"] is not None:
        lines += ["**Request sample**:", "", "```json",
                  json.dumps(op["request_sample"], indent=2), "```", ""]
    return "\n".join(lines)


def raw_type(schema):
    t = schema.get("type", "string")
    fmt = schema.get("format")
    parts = [t + (f" <{fmt}>" if fmt else "")]
    if schema.get("nullable"):
        parts.append("or null")
    if "default" in schema:
        parts.append(f'Default: {schema["default"]}')
    if "enum" in schema:
        parts.append("Enum: " + " ".join(str(e) for e in schema["enum"]))
    if "minItems" in schema or "maxItems" in schema:
        parts.append(f'[{schema.get("minItems", 0)} .. {schema.get("maxItems", "∞")}] items')
    return " ".join(str(p) for p in parts)


def schema_to_md_rows(schema, prefix="", depth=0):
    rows = []
    if schema.get("type") == "object" and schema.get("properties"):
        for name, sub in schema["properties"].items():
            full = f"{prefix}.{name}" if prefix else name
            rows.append({"name": full, "depth": depth, "required": name in schema.get("required", []),
                         "deprecated": sub.get("deprecated", False), "schema": sub,
                         "description": sub.get("description", ""), "raw": raw_type(sub)})
            rows += schema_to_md_rows(sub, full, depth + 1)
    elif schema.get("type") == "array" and isinstance(schema.get("items"), dict):
        rows += schema_to_md_rows(schema["items"], prefix + "[]", depth)
    return rows


def build_openapi(ops, snapshot_date):
    spec = OrderedDict()
    date_part = ""
    m = re.search(r"(\d{1,2} \w+ \d{4})", snapshot_date)
    if m:
        months = {m_: i for i, m_ in enumerate(
            ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], 1)}
        d = m.group(1).split()
        if len(d) == 3 and d[1][:3] in months:
            date_part = f"{d[2]}-{months[d[1][:3]]:02d}-{int(d[0]):02d}"
    spec["openapi"] = "3.0.3"
    spec["info"] = {
        "title": "bexio API (unofficial)",
        "version": f"0.1.0-unofficial{('-' + date_part) if date_part else ''}",
        "description": (
            "**Unofficial** OpenAPI description of the bexio API.\n\n"
            "bexio does not publish an OpenAPI/Swagger definition; this document was "
            "reconstructed programmatically from https://docs.bexio.com by "
            "`scripts/extract_bexio_api_docs.py` in the "
            "[elixir-bexio-client-api](https://github.com/titaniumcoder/elixir-bexio-client-api) repository.\n\n"
            "It is provided as-is, without any warranty of any kind. bexio is a product of "
            "bexio AG; bexio AG is **not** the author of this document, does not maintain it "
            "and is **not** responsible for its content in any way. For questions, corrections "
            "or issues regarding this unofficial description, contact the maintainer listed "
            "below or open an issue in the repository mentioned above. The authoritative "
            "source is always https://docs.bexio.com."
        ),
        "contact": {
            "name": "Rico Metzger (@titaniumcoder)",
            "email": "rico.metzger@titaniumcoder.com",
            "url": "https://github.com/titaniumcoder/elixir-bexio-client-api",
        },
        "x-generated-from": "https://docs.bexio.com/",
        "x-generator": "scripts/extract_bexio_api_docs.py",
        "x-disclaimer": (
            "Unofficial, community-maintained reconstruction. Not affiliated with, "
            "endorsed by, or the responsibility of bexio AG."
        ),
    }
    spec["servers"] = [{"url": "https://api.bexio.com"}]
    spec["security"] = [{"bearerAuth": []}]
    spec["components"] = {"securitySchemes": {
        "bearerAuth": {"type": "http", "scheme": "bearer",
                       "description": "OAuth 2.0 access token obtained from auth.bexio.com "
                                      "(see https://docs.bexio.com/#section/Authentication)"}}}
    groups = []
    paths = OrderedDict()
    for op in ops:
        if op["group"] and op["group"] not in groups:
            groups.append(op["group"])
        p = paths.setdefault(op["path"], OrderedDict())
        method = op["method"].lower()
        if method in ("get", "delete"):
            method = method
        o = OrderedDict()
        o["operationId"] = op["operationId"]
        o["summary"] = op["title"]
        if op["group"]:
            o["tags"] = [op["group"]]
        if op["description"]:
            o["description"] = op["description"]
        params = []
        path_names = set(re.findall(r"\{([^}]+)\}", op["path"]))
        for prm in op["parameters"]:
            if prm["in"] == "path" or prm["name"] not in path_names or prm["in"] != "query":
                params.append(prm)
            else:
                params.append(prm)
        # ensure every path placeholder has a parameter entry
        have = {p_["name"] for p_ in params if p_["in"] == "path"}
        for nm in sorted(path_names - have):
            params.append({"name": nm, "in": "path", "required": True,
                           "schema": {"type": "integer"},
                           "description": "path parameter (not documented individually in the snapshot)"})
        if params:
            o["parameters"] = params
        if op["body_schema"] is not None:
            rb = {"required": op["body_required"],
                  "content": {op["body_ctype"]: {"schema": op["body_schema"]}}}
            if op["request_sample"] is not None:
                rb["content"][op["body_ctype"]]["example"] = op["request_sample"]
            o["requestBody"] = rb
        resp = OrderedDict()
        for code, r in op["responses"].items():
            entry = {}
            if r.get("description"):
                entry["description"] = r["description"]
            content = r.get("content")
            if content:
                entry["content"] = content
            resp[code] = entry
        if resp:
            o["responses"] = resp
        p[method] = o
    spec["tags"] = [{"name": g} for g in groups]
    spec["paths"] = paths
    return spec


def slugify(s):
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")


def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    ap.add_argument("--source", default=DEFAULT_URL,
                    help="URL of https://docs.bexio.com/, or a path to a raw HTML file "
                         "or an MHTML snapshot (default: download the live docs)")
    ap.add_argument("--out-dir", default=os.path.join(os.path.dirname(__file__), "..", "docs"))
    args = ap.parse_args()
    out_dir = os.path.normpath(args.out_dir)
    ref_dir = os.path.join(out_dir, "reference")
    os.makedirs(ref_dir, exist_ok=True)

    print(f"loading docs from {args.source} ...", file=sys.stderr)
    html_text, snapshot_date = load_source(args.source)
    ops, pages, _ = extract(html_text)
    ops = [parse_operation(o) for o in ops]

    # ---- markdown reference ----
    for f in os.listdir(ref_dir):
        os.remove(os.path.join(ref_dir, f))
    files = OrderedDict()
    for op in ops:
        files.setdefault(op["group"] or "Other", []).append(op)
    index = []
    for grp, group_ops in files.items():
        fn = f"{slugify(grp)}.md"
        top = group_ops[0].get("top_group") or grp
        md = [f"# {grp}", "",
              f"Part of **{top}**. Extracted from docs.bexio.com"
             + (f" (snapshot {snapshot_date})" if snapshot_date else "") +
             f". {len(group_ops)} operations.", ""]
        md += ["| Method | Path | Title |", "|---|---|---|"]
        for op in group_ops:
            md.append(f"| `{op['method'].upper()}` | `{op['path']}` | {op['title']} |")
        md.append("")
        for op in group_ops:
            md += [build_markdown_block(op), "---", ""]
            index.append({"group": op.get("top_group") or grp, "tag": grp,
                          "method": op["method"].upper(), "path": op["path"],
                          "title": op["title"], "operationId": op["operationId"]})
        with open(os.path.join(ref_dir, fn), "w") as f:
            f.write("\n".join(md))

    summary = ["# bexio API reference (extracted from docs.bexio.com snapshot)", "",
               "Source: `bexio API documentation.mhtml` (saved from https://docs.bexio.com).",
               "Regenerate with `python3 scripts/extract_bexio_api_docs.py`.", "",
               "Machine-readable index: [`operations.json`](operations.json) — "
               "OpenAPI spec: [`../bexio-openapi.json`](../bexio-openapi.json) / "
               "[`../bexio-openapi.yaml`](../bexio-openapi.yaml).", "",
               "Groups:", ""]
    tops = OrderedDict()
    for grp, group_ops in files.items():
        tops.setdefault(group_ops[0].get("top_group") or grp, []).append((grp, group_ops))
    for top, entries in tops.items():
        summary.append(f"### {top}")
        summary.append("")
        for grp, group_ops in entries:
            summary.append(f"- **{grp}** → [`{slugify(grp)}.md`]({slugify(grp)}.md) ({len(group_ops)} operations)")
        summary.append("")
    for sid, title, _body in pages:
        summary.append(f"- {title} → `page-{slugify(title)[:60]}.md`")
    for sid, title, body in pages:
        with open(os.path.join(ref_dir, f"page-{slugify(title)[:60]}.md"), "w") as f:
            f.write(f"# {title}\n\n{body}\n")
    with open(os.path.join(ref_dir, "README.md"), "w") as f:
        f.write("\n".join(summary) + "\n")
    with open(os.path.join(ref_dir, "operations.json"), "w") as f:
        json.dump(index, f, indent=2)

    # ---- OpenAPI ----
    spec = build_openapi(ops, snapshot_date)
    with open(os.path.join(out_dir, "bexio-openapi.json"), "w") as f:
        json.dump(spec, f, indent=2)
        f.write("\n")
    with open(os.path.join(out_dir, "bexio-openapi.yaml"), "w") as f:
        f.write(to_yaml(spec) + "\n")

    print(f"groups={len(files)} operations={len(ops)} pages={len(pages)}")
    print(f"openapi paths={len(spec['paths'])}")


if __name__ == "__main__":
    main()
