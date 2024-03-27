defmodule XSocial.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix :timeline
  schema "posts" do
    field :body, :string
    field :username, :string, default: "tranquangkha"
    field :likes_count, :integer, default: 0
    field :reposts_count, :integer, default: 0
    field :parent_post_id, :integer
    field :original_post_id, :integer

    belongs_to :user, XSocial.Auth.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> validate_length(:body, min: 2, max: 250)
  end
end
