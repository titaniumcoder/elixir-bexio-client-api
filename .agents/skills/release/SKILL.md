---
name: release
description: Release a new version of the bexio_api_client Hex package. Use when the user asks to release, publish, cut a release, or bump the version.
---

# Release bexio_api_client to Hex.pm

Releases are published automatically by GitHub Actions (`.github/workflows/publish-hex.yml`), which triggers **on any git tag push** and runs `mix test`, `mix dialyzer`, `mix credo`, then `mix hex.publish --yes`. Your job is to prepare a clean, verified release commit and tag — never run `mix hex.publish` locally.

Conventions: commits follow [Conventional Commits](https://www.conventionalcommits.org/), the changelog follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versions follow SemVer.

## Steps

1. **Determine the version bump**
   - Read the changes accumulated under `## [Unreleased]` in `CHANGELOG.md` and compare with the last tag (`git describe --tags --abbrev=0`).
   - SemVer (library is stable at 1.0+): breaking changes → major, new features → minor, bugfixes → patch. Confirm with the user if ambiguous.

2. **Finalize `CHANGELOG.md` (Keep a Changelog)**
   - Rename `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD` (ISO date).
   - Ensure entries are grouped under `### Added` / `### Changed` / `### Fixed` / `### Removed` / `### Deprecated` / `### Security`.
   - Breaking changes listed first under `### Changed` with a bold **BREAKING** marker and a migration note.
   - Add a compare-link for the new version in the footer at the bottom of the file, and keep `[Unreleased]` pointing at `HEAD` (empty section stays at the top).
   - Start a fresh empty `## [Unreleased]` section above the new version.

3. **Bump the version**
   - Update `version:` in `mix.exs` and the installation example in `README.md` to the same version.

4. **Verify**
   - `mix format --check-formatted`
   - `mix test`
   - `mix credo --no-color`
   - `mix dialyzer`
   - Fix everything before continuing. Do not release with failures.

5. **Commit and tag (Conventional Commits)**
   - Commit with `chore: release vX.Y.Z` (or `chore(release): vX.Y.Z`); include the changelog + version bump.
   - Tag: `git tag -a vX.Y.Z -m "vX.Y.Z"`.
   - Do **not** push automatically — ask the user, then `git push origin main vX.Y.Z`. The tag push triggers the Hex publish workflow.

6. **Post-release check**
   - Remind the user to verify the GitHub Actions run succeeded and that the new version appears on https://hex.pm/packages/bexio_api_client.

## Notes

- Version tags exist for all past releases (`git tag -l`) — keep the `vX.Y.Z` format.
- While developing (not releasing), put every user-visible change under `## [Unreleased]` in `CHANGELOG.md` in the same commit as the change (e.g. a `feat:` commit also adds its entry under Unreleased → Added).
- If a release contains breaking changes, the commit must be `feat!:`/`fix!:` with a `BREAKING CHANGE:` footer, and the CHANGELOG entry must carry the bold **BREAKING** marker.