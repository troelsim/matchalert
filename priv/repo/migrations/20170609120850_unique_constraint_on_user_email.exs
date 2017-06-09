defmodule Headsup.Repo.Migrations.UniqueConstraintOnUserEmail do
  use Ecto.Migration

  def change do
    create unique_index(:users_subscriptions, [:email])
  end
end
