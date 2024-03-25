defmodule XSocial.Repo.Migrations.UpdatePost do
  use Ecto.Migration

  def up do
    execute """
    CREATE SCHEMA "timeline";
    """

    # Ensure you replace 'your_original_schema' with your actual original schema name
    execute "ALTER TABLE posts SET SCHEMA timeline"
  end

  def down do
    # To revert the migration, move the table back to the original schema
    execute "ALTER TABLE timeline.posts SET SCHEMA public"

    execute """
    DROP SCHEMA "timeline";
    """
  end
end
