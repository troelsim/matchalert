defmodule Matchalert.Web.EmailView do
  use Matchalert.Web, :view

  def players_string(%{"players" => [player1, player2]}) do
    "#{player1["name"]} vs. #{player2["name"]}"
  end

  def player1(%{"players" => [player, _]}) do player["name"] end
  def player2(%{"players" => [_, player]}) do player["name"] end
end
