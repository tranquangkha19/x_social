defmodule XSocial.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    execute """
    CREATE SCHEMA "auth";
    """

    create table(:users, prefix: :auth) do
      add :username, :text
      add :password, :text
      add :name, :text
      add :email, :text

      timestamps(default: fragment("NOW()"))
    end
  end

  def down do
    drop table(:users, prefix: :social_app)

    execute """
    DROP SCHEMA "auth";
    """
  end
end
