defmodule XSocial.Repo.Migrations.UpdatePosts do
  use Ecto.Migration

  def change do
    alter table(:posts, prefix: :timeline) do
      add :user_id, references(:users, prefix: :auth)
      add :parent_post_id, references(:posts, prefix: :timeline)
      add :original_post_id, references(:posts, prefix: :timeline)
    end
  end
end
