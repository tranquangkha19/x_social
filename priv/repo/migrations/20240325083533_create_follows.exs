defmodule XSocial.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def up do
    execute """
    CREATE SCHEMA "relation";
    """

    create table(:follows, prefix: :relation) do
      add :followed_at, :naive_datetime

      add :user_id, references(:users, prefix: :auth)
      add :followee_id, references(:users, prefix: :auth)

      timestamps(default: fragment("NOW()"))
    end
  end

  def down do
    drop table(:follows, prefix: :relation)

    execute """
    DROP SCHEMA "relation";
    """
  end
end
