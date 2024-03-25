defmodule XSocial.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes, prefix: :timeline) do
      add :user_name, :text
      add :liked_at, :naive_datetime

      add :user_id, references(:users, prefix: :auth)
      add :post_id, references(:posts, prefix: :timeline)

      timestamps(default: fragment("NOW()"))
    end
  end
end
