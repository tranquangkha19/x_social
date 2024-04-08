defmodule XSocial.Relation.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix :relation
  schema "notifications" do
    belongs_to :user, XSocial.Auth.User
    belongs_to :actioner, XSocial.Auth.User
    belongs_to :post, XSocial.Timeline.Post
    field :type, :string
    field :active, :boolean

    timestamps()
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [:user_id, :actioner_id]

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end

defmodule XSocial.Relation.NotificationType do
  def like, do: "like"
  def repost, do: "repost"
  def reply, do: "reply"
  def enum, do: ["like", "repost", "reply"]
end
