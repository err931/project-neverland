# SPDX-FileCopyrightText: 2026 Minoru Maekawa
#
# SPDX-License-Identifier: FSL-1.1-ALv2

%{
  configs: [
    %{
      name: "default",
      strict: true,
      plugins: [
        {ExSlop, []}
      ],
      checks: %{
        extra: [
          {Credo.Check.Warning.ExpensiveEmptyEnumCheck, []},
          {Credo.Check.Refactor.AppendSingleItem, []},
          {Credo.Check.Refactor.DoubleBooleanNegation, []},
          {Credo.Check.Refactor.CondStatements, []},
          {Credo.Check.Refactor.MapMap, []},
          {Credo.Check.Refactor.FilterFilter, []},
          {Credo.Check.Refactor.RejectReject, []},
          {Credo.Check.Refactor.FilterCount, []},
          {Credo.Check.Refactor.NegatedConditionsInUnless, []},
          {Credo.Check.Refactor.UnlessWithElse, []}
        ]
      }
    }
  ]
}
