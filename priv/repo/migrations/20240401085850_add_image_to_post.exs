defmodule XSocial.Repo.Migrations.AddImageToPost do
  use Ecto.Migration

  def change do
    alter table(:posts, prefix: :timeline) do
      add :image_url, :text
    end
  end
end
