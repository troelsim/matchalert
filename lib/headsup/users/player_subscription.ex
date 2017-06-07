defmodule Headsup.Users.PlayerSubscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Headsup.Users.PlayerSubscription


  schema "users_player_subscriptions" do

    timestamps()
  end

  @doc false
  def changeset(%PlayerSubscription{} = player_subscription, attrs) do
    player_subscription
    |> cast(attrs, [])
    |> validate_required([])
  end
end
