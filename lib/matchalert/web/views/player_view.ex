defmodule Matchalert.Web.PlayerView do
  use Matchalert.Web, :view

  def render("index.json", %{players: players}) do
    %{
      players: players |> Enum.map(&(%{id: &1.id, name: &1.name}))
    }
  end
end
