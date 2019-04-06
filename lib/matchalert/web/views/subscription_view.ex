defmodule Matchalert.Web.SubscriptionView do
  use Matchalert.Web, :view
  def render("players.json", %{players: players}) do
    %{
      players: players |> Enum.map(&(%{id: &1.id, name: &1.name}))
    }
  end

  def render("matches.json", %{matches: matches}) do
    %{matches: matches}
  end
end
