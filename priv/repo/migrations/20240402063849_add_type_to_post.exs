defmodule XSocial.Repo.Migrations.AddTypeToPost do
  use Ecto.Migration

  def change do
    alter table(:posts, prefix: :timeline) do
      add :type, :text
    end
  end
end
