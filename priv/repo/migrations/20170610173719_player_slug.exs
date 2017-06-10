defmodule Headsup.Repo.Migrations.PlayerSlug do
  use Ecto.Migration

  def change do
    alter table(:users_players) do
      add :slug, :string
    end
  end
end
