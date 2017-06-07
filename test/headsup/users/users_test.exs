defmodule Headsup.UsersTest do
  use Headsup.DataCase

  alias Headsup.Users

  describe "subscriptions" do
    alias Headsup.Users.Subscription

    @valid_attrs %{email: "some email"}
    @update_attrs %{email: "some updated email"}
    @invalid_attrs %{email: nil}

    def subscription_fixture(attrs \\ %{}) do
      {:ok, subscription} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_subscription()

      subscription
    end

    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Users.list_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Users.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      assert {:ok, %Subscription{} = subscription} = Users.create_subscription(@valid_attrs)
      assert subscription.email == "some email"
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_subscription(@invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      assert {:ok, subscription} = Users.update_subscription(subscription, @update_attrs)
      assert %Subscription{} = subscription
      assert subscription.email == "some updated email"
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_subscription(subscription, @invalid_attrs)
      assert subscription == Users.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Users.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Users.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Users.change_subscription(subscription)
    end
  end

  describe "players" do
    alias Headsup.Users.Player

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Users.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Users.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Users.create_player(@valid_attrs)
      assert player.name == "some name"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, player} = Users.update_player(player, @update_attrs)
      assert %Player{} = player
      assert player.name == "some updated name"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_player(player, @invalid_attrs)
      assert player == Users.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Users.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Users.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Users.change_player(player)
    end
  end

  describe "player_subscriptions" do
    alias Headsup.Users.PlayerSubscription

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def player_subscription_fixture(attrs \\ %{}) do
      {:ok, player_subscription} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_player_subscription()

      player_subscription
    end

    test "list_player_subscriptions/0 returns all player_subscriptions" do
      player_subscription = player_subscription_fixture()
      assert Users.list_player_subscriptions() == [player_subscription]
    end

    test "get_player_subscription!/1 returns the player_subscription with given id" do
      player_subscription = player_subscription_fixture()
      assert Users.get_player_subscription!(player_subscription.id) == player_subscription
    end

    test "create_player_subscription/1 with valid data creates a player_subscription" do
      assert {:ok, %PlayerSubscription{} = player_subscription} = Users.create_player_subscription(@valid_attrs)
    end

    test "create_player_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_player_subscription(@invalid_attrs)
    end

    test "update_player_subscription/2 with valid data updates the player_subscription" do
      player_subscription = player_subscription_fixture()
      assert {:ok, player_subscription} = Users.update_player_subscription(player_subscription, @update_attrs)
      assert %PlayerSubscription{} = player_subscription
    end

    test "update_player_subscription/2 with invalid data returns error changeset" do
      player_subscription = player_subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_player_subscription(player_subscription, @invalid_attrs)
      assert player_subscription == Users.get_player_subscription!(player_subscription.id)
    end

    test "delete_player_subscription/1 deletes the player_subscription" do
      player_subscription = player_subscription_fixture()
      assert {:ok, %PlayerSubscription{}} = Users.delete_player_subscription(player_subscription)
      assert_raise Ecto.NoResultsError, fn -> Users.get_player_subscription!(player_subscription.id) end
    end

    test "change_player_subscription/1 returns a player_subscription changeset" do
      player_subscription = player_subscription_fixture()
      assert %Ecto.Changeset{} = Users.change_player_subscription(player_subscription)
    end
  end
end
