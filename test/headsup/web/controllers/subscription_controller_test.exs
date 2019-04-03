defmodule Matchalert.Web.SubscriptionControllerTest do
  use Matchalert.Web.ConnCase

  alias Matchalert.Users

  @create_attrs %{email: "some email"}
  @update_attrs %{email: "some updated email"}
  @invalid_attrs %{email: nil}

  def fixture(:subscription) do
    {:ok, subscription} = Users.create_subscription(@create_attrs)
    subscription
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, subscription_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Subscriptions"
  end

  test "renders form for new subscriptions", %{conn: conn} do
    conn = get conn, subscription_path(conn, :new)
    assert html_response(conn, 200) =~ "New Subscription"
  end

  test "creates subscription and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, subscription_path(conn, :create), subscription: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == subscription_path(conn, :show, id)

    conn = get conn, subscription_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Subscription"
  end

  test "does not create subscription and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, subscription_path(conn, :create), subscription: @invalid_attrs
    assert html_response(conn, 200) =~ "New Subscription"
  end

  test "renders form for editing chosen subscription", %{conn: conn} do
    subscription = fixture(:subscription)
    conn = get conn, subscription_path(conn, :edit, subscription)
    assert html_response(conn, 200) =~ "Edit Subscription"
  end

  test "updates chosen subscription and redirects when data is valid", %{conn: conn} do
    subscription = fixture(:subscription)
    conn = put conn, subscription_path(conn, :update, subscription), subscription: @update_attrs
    assert redirected_to(conn) == subscription_path(conn, :show, subscription)

    conn = get conn, subscription_path(conn, :show, subscription)
    assert html_response(conn, 200) =~ "some updated email"
  end

  test "does not update chosen subscription and renders errors when data is invalid", %{conn: conn} do
    subscription = fixture(:subscription)
    conn = put conn, subscription_path(conn, :update, subscription), subscription: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Subscription"
  end

  test "deletes chosen subscription", %{conn: conn} do
    subscription = fixture(:subscription)
    conn = delete conn, subscription_path(conn, :delete, subscription)
    assert redirected_to(conn) == subscription_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, subscription_path(conn, :show, subscription)
    end
  end
end
