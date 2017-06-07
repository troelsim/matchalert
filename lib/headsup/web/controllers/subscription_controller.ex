defmodule Headsup.Web.SubscriptionController do
  use Headsup.Web, :controller

  alias Headsup.Users

  def index(conn, _params) do
    subscriptions = Users.list_subscriptions()
    render(conn, "index.html", subscriptions: [])
  end

  def new(conn, _params) do
    changeset = Users.change_subscription(%Headsup.Users.Subscription{})
    players = Users.list_players()
    render(conn, "new.html", changeset: changeset, players: players)
  end

  def create(conn, %{"subscription" => subscription_params}) do
    response = case Users.create_subscription(subscription_params) do
      {:ok, subscription} ->
        IO.puts("OK")
        IO.inspect(subscription)
        conn
        |> put_flash(:info, "Email address verified successfully.")
        |> redirect(to: subscription_path(conn, :show, subscription))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("ERROR")
        render(conn, "new.html", changeset: changeset)
    end
    response
  end

  def verify(conn, %{"uuid" => uuid}) do
    case Users.verify_email(uuid) do
      {:ok, subscription} ->
        IO.puts("OK")
        conn
        |> put_flash(:info, "Subscription created successfully.")
        |> redirect(to: subscription_path(conn, :show, subscription))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("ERROR")
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    subscription = Users.get_subscription!(id)
    render(conn, "show.html", subscription: subscription)
  end

  def edit(conn, %{"id" => id}) do
    subscription = Users.get_subscription!(id)
    changeset = Users.change_subscription(subscription)
    players = Users.list_players()
    render(conn, "edit.html", subscription: subscription, changeset: changeset, players: players)
  end

  def update(conn, %{"id" => id, "subscription" => subscription_params}) do
    subscription = Users.get_subscription!(id)
    players = Users.list_players()

    case Users.set_players_for_subscription(subscription, subscription_params) do
      {:ok, subscription} ->
        conn
        |> put_flash(:info, "Subscription updated successfully.")
        |> redirect(to: subscription_path(conn, :show, subscription))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", subscription: subscription, changeset: changeset, players: players)
    end
  end

  def delete(conn, %{"id" => id}) do
    subscription = Users.get_subscription!(id)
    {:ok, _subscription} = Users.delete_subscription(subscription)

    conn
    |> put_flash(:info, "Subscription deleted successfully.")
    |> redirect(to: subscription_path(conn, :index))
  end
end
