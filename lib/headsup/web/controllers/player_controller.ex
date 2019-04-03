defmodule Matchalert.Web.PlayerController do
  use Matchalert.Web, :controller

  alias Matchalert.Users

  def index(conn, _params) do
    players = Users.list_players()
    render(conn, "index.json", players: players)
  end

end
