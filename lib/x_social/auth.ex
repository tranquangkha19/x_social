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

  def get_users_by_ids(user_ids) do
    Repo.all(
      from user in User,
        where: user.id in ^user_ids,
        select: user
    )
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && check_password(user, password) -> {:ok, user}
      true -> {:error, :invalid_credentials}
    end
  end

  defp check_password(user, password) do
    password == user.password
    # Pbkdf2.verify_pass(password, user.password_hash)
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
