defmodule MatchesTest do
  use ExUnit.Case
  import Matchalert.Matches.Getter
  import Matchalert.Matches.Status
  doctest Matchalert.Matches.Getter
  doctest Matchalert.Matches.Status

  test "the truth" do
    assert 1 + 1 == 2
  end
end
