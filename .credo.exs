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
        # our structs mirror the bexio API objects 1:1, so they legitimately
        # have more fields than credo's default allows
        {Credo.Check.Warning.StructFieldAmount, max_fields: 45},
      ]
    }
  ]
}
