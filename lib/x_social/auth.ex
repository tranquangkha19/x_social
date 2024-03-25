defmodule XSocial.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias XSocial.Repo

  alias XSocial.Auth.User

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by(params), do: Repo.get_by(User, params)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(user, params \\ %{})

  def change_user(%User{} = user, params) do
    User.changeset(user, params)
  end
end
