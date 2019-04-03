defmodule Matchalert.Repo.Migrations.AddUuidToSubscription do
  use Ecto.Migration

  def change do
    alter table(:users_subscriptions) do
      add :uuid, :string
    end
  end
end
