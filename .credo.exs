# .credo.exs or config/.credo.exs
%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "src/", "web/", "apps/"],
        excluded: []
      },
      plugins: [],
      requires: [],
      strict: false,
      parse_timeout: 5000,
      color: true,
      checks: [
        # struct field counts come from the bexio API objects, not from our
        # design decisions - so this check does not apply to us
        {Credo.Check.Warning.StructFieldAmount, false},
      ]
    }
  ]
}
