defmodule XSocial.Repo.Migrations.AddActiveFlagToFollow do
  use Ecto.Migration

  def change do
    alter table(:follows, prefix: :relation) do
      add :active, :boolean
    end
  end
end
