defmodule Headsup.Web.SubscriptionView do
  use Headsup.Web, :view
  def render("players.json", %{players: players}) do
    %{
      players: players |> Enum.map(&(%{id: &1.id, name: &1.name}))
    }
  end
end
