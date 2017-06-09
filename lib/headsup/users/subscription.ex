defmodule Headsup.Users.Subscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Headsup.Users.Subscription


  schema "users_subscriptions" do
    field :email, :string
    field :uuid, :string
    field :verified, :boolean

    many_to_many :players, Headsup.Users.Player, join_through: Headsup.Users.PlayerSubscription, on_replace: :delete, on_delete: :delete_all
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
