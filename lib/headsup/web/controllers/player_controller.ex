defmodule Headsup.Web.PlayerController do
  use Headsup.Web, :controller

  alias Headsup.Users

  def index(conn, _params) do
    players = Users.list_players()
    render(conn, "index.json", players: players)
  end

end
