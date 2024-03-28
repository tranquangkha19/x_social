defmodule XSocial.Relation.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix :relation
  schema "follows" do
    belongs_to :user, XSocial.Auth.User
    # the user that being followed
    belongs_to :followee, XSocial.Auth.User
    field :followed_at, :naive_datetime

    timestamps()
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [:user_id, :followee_id]

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end
