defmodule Matchalert.Users.PlayerSubscription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Matchalert.Users.PlayerSubscription


  schema "users_player_subscriptions" do
    belongs_to :subscription, Matchalert.Users.Subscription
    belongs_to :player, Matchalert.Users.Player
    timestamps()
  end

  @doc false
  def changeset(%PlayerSubscription{} = player_subscription, attrs) do
    player_subscription
    |> cast(attrs, [:subscription_id, :player_id])
    |> validate_required([:subscription_id, :player_id])
  end
end
