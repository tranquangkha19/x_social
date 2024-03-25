defmodule XSocial.Timeline.Like do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix :timeline
  schema "likes" do
    field :username, :string
    field :liked_at, :naive_datetime
    belongs_to :user, XSocial.Auth.User
    belongs_to :post, XSocial.Timeline.Post

    timestamps()
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [:user_id, :post_id]

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end
