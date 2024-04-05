defmodule XSocial.Repo.Migrations.AddRepliesCountToPost do
  use Ecto.Migration

  def change do
    alter table(:posts, prefix: :timeline) do
      add :replies_count, :integer, default: 0
    end
  end
end
