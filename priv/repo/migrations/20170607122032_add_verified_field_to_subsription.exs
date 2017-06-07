defmodule Headsup.Repo.Migrations.AddVerifiedFieldToSubsription do
  use Ecto.Migration

  def change do
    alter table(:users_subscriptions) do
      add :verified, :boolean
    end
  end
end
