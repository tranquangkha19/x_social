defmodule XSocial.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix :timeline
  schema "posts" do
    field :body, :string
    field :image_url, :string
    field :username, :string, default: "tranquangkha"
    field :likes_count, :integer, default: 0
    field :reposts_count, :integer, default: 0
    field :replies_count, :integer, default: 0
    field :parent_post_id, :integer
    field :type, :string

    belongs_to :original_post, XSocial.Timeline.Post
    belongs_to :user, XSocial.Auth.User

    timestamps(type: :utc_datetime)
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required([:body])
    |> validate_length(:body, min: 2, max: 250)
  end
end

defmodule XSocial.Timeline.PostType do
  def post, do: "post"
  def repost, do: "repost"
  def reply, do: "reply"
  def enum, do: ["post", "repost", "reply"]
end
