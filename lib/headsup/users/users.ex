defmodule Headsup.Users do
  @moduledoc """
  The boundary for the Users system.
  """

  import Ecto.Query, warn: false
  alias Headsup.Repo

  alias Headsup.Users.Subscription

  @doc """
  Returns the list of subscriptions.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriptions do
    Repo.all(Subscription)
  end

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %Subscription{}

      iex> get_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(id) do
    Repo.get!(Subscription, id)
    |> Repo.preload(:players)
  end

  @doc """
  Creates a subscription.

  ## Examples

      iex> create_subscription(%{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(IO.inspect(Map.merge(attrs, %{"uuid" => UUID.uuid1()})))
    |> Repo.insert()
  end

  def verify_email(uuid) do
    Repo.get_by(Subscription, uuid: uuid)
    |> Ecto.Changeset.cast(%{"uuid" => uuid, "verified" => true}, [:uuid, :verified])
    |> Repo.update()
    |> IO.inspect
  end

  @doc """
  Updates a subscription.

  ## Examples

      iex> update_subscription(subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def set_players_for_subscription(%Subscription{} = subscription, attrs) do
    player_ids = attrs["players"] |> Enum.map(&String.to_integer/1)
    players = Repo.all(from(p in Headsup.Users.Player, where: p.id in ^player_ids))
    get_subscription!(IO.inspect(subscription).id)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:players, players)
    |> Repo.update()
  end

  @doc """
  Deletes a Subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(subscription)
      %Ecto.Changeset{source: %Subscription{}}

  """
  def change_subscription(%Subscription{} = subscription) do
    Subscription.changeset(subscription, %{})
  end

  alias Headsup.Users.Player

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player)
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{source: %Player{}}

  """
  def change_player(%Player{} = player) do
    Player.changeset(player, %{})
  end

  alias Headsup.Users.PlayerSubscription

  @doc """
  Returns the list of player_subscriptions.

  ## Examples

      iex> list_player_subscriptions()
      [%PlayerSubscription{}, ...]

  """
  def list_player_subscriptions do
    Repo.all(PlayerSubscription)
  end

  @doc """
  Gets a single player_subscription.

  Raises `Ecto.NoResultsError` if the Player subscription does not exist.

  ## Examples

      iex> get_player_subscription!(123)
      %PlayerSubscription{}

      iex> get_player_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_subscription!(id), do: Repo.get!(PlayerSubscription, id)

  @doc """
  Creates a player_subscription.

  ## Examples

      iex> create_player_subscription(%{field: value})
      {:ok, %PlayerSubscription{}}

      iex> create_player_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player_subscription(attrs \\ %{}) do
    %PlayerSubscription{}
    |> PlayerSubscription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player_subscription.

  ## Examples

      iex> update_player_subscription(player_subscription, %{field: new_value})
      {:ok, %PlayerSubscription{}}

      iex> update_player_subscription(player_subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player_subscription(%PlayerSubscription{} = player_subscription, attrs) do
    player_subscription
    |> PlayerSubscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PlayerSubscription.

  ## Examples

      iex> delete_player_subscription(player_subscription)
      {:ok, %PlayerSubscription{}}

      iex> delete_player_subscription(player_subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player_subscription(%PlayerSubscription{} = player_subscription) do
    Repo.delete(player_subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player_subscription changes.

  ## Examples

      iex> change_player_subscription(player_subscription)
      %Ecto.Changeset{source: %PlayerSubscription{}}

  """
  def change_player_subscription(%PlayerSubscription{} = player_subscription) do
    PlayerSubscription.changeset(player_subscription, %{})
  end
end
