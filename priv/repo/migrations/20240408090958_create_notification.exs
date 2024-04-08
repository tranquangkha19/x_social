defmodule XSocial.Repo.Migrations.CreateNotification do
  use Ecto.Migration

  def change do
    create table(:notifications, prefix: :relation) do
      add :user_id, references(:users, prefix: :auth)
      add :actioner_id, references(:users, prefix: :auth)
      add :post_id, references(:posts, prefix: :timeline)
      add :type, :text
      add :active, :boolean, default: true

      timestamps(default: fragment("NOW()"))
    end
  end
end
