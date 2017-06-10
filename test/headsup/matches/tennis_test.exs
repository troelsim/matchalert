defmodule MatchesTest do
  use ExUnit.Case
  import Headsup.Matches.Getter
  import Headsup.Matches.Status
  doctest Headsup.Matches.Getter
  doctest Headsup.Matches.Status

  test "the truth" do
    assert 1 + 1 == 2
  end
end
