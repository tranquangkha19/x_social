defmodule XSocial.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix :auth
  schema "users" do
    field :username, :string
    field :password, :string
    field :email, :string
    field :name, :string

    timestamps()
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [:username]

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:email, :username])
  end
end