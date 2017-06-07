defmodule Headsup.Users.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias Headsup.Users.Player


  schema "users_players" do
    field :name, :string
    has_many :player_subscriptions, PlayerSubscription
    timestamps()
  end

  @doc false
  def changeset(%Player{} = player, attrs) do
    player
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
