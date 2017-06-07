defmodule Headsup.Users.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Headsup.Users.Subscription


  schema "users_subscriptions" do
    field :email, :string
    field :uuid, :string
    field :verified, :boolean

    has_many :player_subscriptions, PlayerSubscription

    timestamps()
  end

  @doc false
  def changeset(%Subscription{} = subscription, attrs) do
    subscription
    |> cast(attrs, [:email, :uuid])
    |> validate_format(:email, ~r/@/)
    |> validate_required([:email, :uuid])
  end
end
