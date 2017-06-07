defmodule Headsup.Web.PlayerSubscriptionControllerTest do
  use Headsup.Web.ConnCase

  alias Headsup.Users

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:player_subscription) do
    {:ok, player_subscription} = Users.create_player_subscription(@create_attrs)
    player_subscription
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, player_subscription_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Player subscriptions"
  end

  test "renders form for new player_subscriptions", %{conn: conn} do
    conn = get conn, player_subscription_path(conn, :new)
    assert html_response(conn, 200) =~ "New Player subscription"
  end

  test "creates player_subscription and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, player_subscription_path(conn, :create), player_subscription: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == player_subscription_path(conn, :show, id)

    conn = get conn, player_subscription_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Player subscription"
  end

  test "does not create player_subscription and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, player_subscription_path(conn, :create), player_subscription: @invalid_attrs
    assert html_response(conn, 200) =~ "New Player subscription"
  end

  test "renders form for editing chosen player_subscription", %{conn: conn} do
    player_subscription = fixture(:player_subscription)
    conn = get conn, player_subscription_path(conn, :edit, player_subscription)
    assert html_response(conn, 200) =~ "Edit Player subscription"
  end

  test "updates chosen player_subscription and redirects when data is valid", %{conn: conn} do
    player_subscription = fixture(:player_subscription)
    conn = put conn, player_subscription_path(conn, :update, player_subscription), player_subscription: @update_attrs
    assert redirected_to(conn) == player_subscription_path(conn, :show, player_subscription)

    conn = get conn, player_subscription_path(conn, :show, player_subscription)
    assert html_response(conn, 200)
  end

  test "does not update chosen player_subscription and renders errors when data is invalid", %{conn: conn} do
    player_subscription = fixture(:player_subscription)
    conn = put conn, player_subscription_path(conn, :update, player_subscription), player_subscription: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Player subscription"
  end

  test "deletes chosen player_subscription", %{conn: conn} do
    player_subscription = fixture(:player_subscription)
    conn = delete conn, player_subscription_path(conn, :delete, player_subscription)
    assert redirected_to(conn) == player_subscription_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, player_subscription_path(conn, :show, player_subscription)
    end
  end
end
