defmodule Matchalert.Repo.Migrations.CreateMatchalert.Users.PlayerSubscription do
  use Ecto.Migration

  def change do
    create table(:users_player_subscriptions) do

      timestamps()
    end

  end
end
