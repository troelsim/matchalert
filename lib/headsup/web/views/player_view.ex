defmodule Headsup.Web.PlayerView do
  use Headsup.Web, :view

  def render("index.json", %{players: players}) do
    %{
      players: players |> Enum.map(&(&1.name))
    }
  end
end
