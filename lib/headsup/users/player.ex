defmodule Headsup.Users.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias Headsup.Users.Player


  schema "users_players" do
    field :name, :string
    field :slug, :string
    many_to_many :subscriptions, Headsup.Users.Subscription, join_through: Headsup.Users.PlayerSubscription, on_replace: :delete
    timestamps()
  end

  @doc false
  def changeset(%Player{} = player, attrs) do
    attrs = attrs |> Map.put(:slug, Slugger.slugify_downcase(attrs.name))
    player
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:name)
  end
end
