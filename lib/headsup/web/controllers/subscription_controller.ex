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
    players = Users.list_players()
    response = case Users.create_subscription(subscription_params) do
      {:ok, subscription} ->
        IO.puts("OK")
        IO.inspect(subscription)
        conn
        |> redirect(to: subscription_path(conn, :thanks))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("ERROR")
        render(conn, "new.html", changeset: changeset, players: players)
    end
    response
  end

  def thanks(conn, %{}) do
    render(conn, "thanks.html")
  end

  def players(conn, %{"uuid" => uuid}) do
    subscription = Users.get_subscription!(uuid)
    render(conn, "players.json", players: subscription.players)
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

  def edit(conn, %{"uuid" => uuid}) do
    subscription = Users.get_subscription!(uuid)
    verified = subscription.verified
    case Users.verify_email(uuid) do
      {:ok, subscription} ->
        changeset = Users.change_subscription(subscription)
        players = Users.list_players()
        case verified do
          true -> conn
          _ -> conn |> put_flash(:info, "Yay, your subscription has been activated")
        end
        |> render("edit.html", subscription: subscription, changeset: changeset, players: players)
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, %{"uuid" => uuid, "subscription" => subscription_params}) do
    subscription = Users.get_subscription!(uuid)
    players = Users.list_players()

    case Users.set_players_for_subscription(subscription, subscription_params) do
      {:ok, subscription} ->
        IO.puts("OK")
        conn
        |> put_flash(:info, "Subscription updated successfully.")
        |> redirect(to: subscription_path(conn, :edit, subscription.uuid))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("ROOR")
        render(conn, "edit.html", subscription: subscription, changeset: changeset, players: players)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    subscription = Users.get_subscription!(uuid)
    {:ok, _subscription} = Users.delete_subscription(subscription)

    conn
    |> put_flash(:info, "Subscription deleted successfully.")
    |> redirect(to: subscription_path(conn, :new))
  end
end
