defmodule Matchalert.Web.PageController do
  use Matchalert.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
