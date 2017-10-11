%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      requires: [],
      check_for_updates: true,
      strict: false,
      checks: [
        {Credo.Check.Readability.MaxLineLength, max_length: 100},
        {Credo.Check.Refactor.PipeChainStart, false},
        {Credo.Check.Design.TagTODO, false},
        {Credo.Check.Design.AliasUsage, false},
        {Credo.Check.Readability.ParenthesesOnZeroArityDefs, false}
      ]
    }
  ]
}
