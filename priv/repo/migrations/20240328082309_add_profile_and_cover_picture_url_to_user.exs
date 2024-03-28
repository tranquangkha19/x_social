defmodule XSocial.Repo.Migrations.AddProfileAndCoverPictureUrlToUser do
  use Ecto.Migration

  def change do
    alter table(:users, prefix: :auth) do
      add :profile_picture_url, :text
      add :cover_picture_url, :text
    end
  end
end
