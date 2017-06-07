defmodule Headsup.Web.PageController do
  use Headsup.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
