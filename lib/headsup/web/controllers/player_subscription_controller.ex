defmodule Headsup.Web.PlayerSubscriptionController do
  use Headsup.Web, :controller

  alias Headsup.Users

  def index(conn, _params) do
    player_subscriptions = Users.list_player_subscriptions()
    render(conn, "index.html", player_subscriptions: player_subscriptions)
  end

  def new(conn, _params) do
    changeset = Users.change_player_subscription(%Headsup.Users.PlayerSubscription{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"player_subscription" => player_subscription_params}) do
    case Users.create_player_subscription(player_subscription_params) do
      {:ok, player_subscription} ->
        conn
        |> put_flash(:info, "Player subscription created successfully.")
        |> redirect(to: player_subscription_path(conn, :show, player_subscription))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    player_subscription = Users.get_player_subscription!(id)
    render(conn, "show.html", player_subscription: player_subscription)
  end

  def edit(conn, %{"id" => id}) do
    player_subscription = Users.get_player_subscription!(id)
    changeset = Users.change_player_subscription(player_subscription)
    render(conn, "edit.html", player_subscription: player_subscription, changeset: changeset)
  end

  def update(conn, %{"id" => id, "player_subscription" => player_subscription_params}) do
    player_subscription = Users.get_player_subscription!(id)

    case Users.update_player_subscription(player_subscription, player_subscription_params) do
      {:ok, player_subscription} ->
        conn
        |> put_flash(:info, "Player subscription updated successfully.")
        |> redirect(to: player_subscription_path(conn, :show, player_subscription))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", player_subscription: player_subscription, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    player_subscription = Users.get_player_subscription!(id)
    {:ok, _player_subscription} = Users.delete_player_subscription(player_subscription)

    conn
    |> put_flash(:info, "Player subscription deleted successfully.")
    |> redirect(to: player_subscription_path(conn, :index))
  end
end
