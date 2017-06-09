defmodule Matches.Change do
  def handle_match_changes(changes) do
    Enum.map(changes, &handle_match_change/1)
  end

  def handle_match_change({nil, "Finished", _}) do end
  def handle_match_change({"interrupted", "In progress", match}) do
    IO.puts "Match resumed:"
    print_match_details(match)
  end
  def handle_match_change({"Not started", "In progress", match}) do
    IO.puts "Match starting:"
    print_match_details(match)
  end
  def handle_match_change({"In progress", "Finished", match}) do
    IO.puts "Match finished"
    print_match_details(match)
  end
  def handle_match_change({from, to, match}) do
    IO.puts "#{from} -> #{to}"
    print_match_details(match)
  end

  def print_match_details(match) do
    IO.puts player_names(match)
    IO.puts "#{status(match)}: #{tournament_round(match)} at #{tournament(match)}"
    IO.puts ""
  end

  def player_names(%{"players" => [player1, player2]}) do
    "#{player1["name"]} vs. #{player2["name"]}"
  end

  def status(%{"status" => status}) do status end

  def tournament_round(%{"round" => round}) do round end

  def tournament(%{"tournament" => tournament}) do tournament end
end
