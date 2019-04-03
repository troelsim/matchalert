defmodule Matchalert.Repo.Migrations.PlayerSubscriptionRelations do
  use Ecto.Migration

  def change do
    alter table(:users_player_subscriptions) do
      add :player_id, references(:users_players)
      add :subscription_id, references(:users_subscriptions)
    end
  end
end
