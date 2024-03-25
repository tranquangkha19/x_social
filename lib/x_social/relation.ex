defmodule XSocial.Relation do
  @moduledoc """
  The Relation context.
  """

  import Ecto.Query, warn: false
  alias XSocial.Repo

  alias XSocial.Relation.Follow

  # get all followees of a user
  # the use follow them (followees)
  def get_all_followees(user_id) do
    Repo.all(from follow in Follow, where: follow.user_id == ^user_id, select: follow)
  end

  # get all followers of a user
  def get_all_followers(user_id) do
    Repo.all(from follow in Follow, where: follow.followee_id == ^user_id, select: follow)
  end
end
