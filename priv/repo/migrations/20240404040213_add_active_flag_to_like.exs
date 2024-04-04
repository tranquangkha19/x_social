defmodule XSocial.Repo.Migrations.AddActiveFlagToLike do
  use Ecto.Migration

  def change do
    alter table(:likes, prefix: :timeline) do
      add :active, :boolean, default: true
    end
  end
end
