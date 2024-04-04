defmodule XSocial.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias XSocial.Repo

  alias XSocial.Auth.User

  @default_profile_picture_url "https://i.pinimg.com/564x/ad/57/b1/ad57b11e313616c7980afaa6b9cc6990.jpg"
  @default_cover_picture_url "https://pbs.twimg.com/profile_banners/628253959/1702375128/1500x500"

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

  def create_user(%{username: username} = attrs) do
    with user when is_nil(user) <-
           get_user_by(%{username: username}) do
      attrs =
        Map.merge(attrs, %{
          name: username,
          profile_picture_url: @default_profile_picture_url,
          cover_picture_url: @default_cover_picture_url
        })

      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    else
      _ ->
        {:error, "Account already exists!"}
    end
  end

  def authenticate_user(username, password) do
    user = Repo.get_by(User, username: username)

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
