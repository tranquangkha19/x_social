defmodule XSocial.Relation do
  @moduledoc """
  The Relation context.
  """

  import Ecto.Query, warn: false
  alias XSocial.Repo

  alias XSocial.Relation.Follow

  # get all followees of a user
  # the use follow them (followees)

  def count_followers_and_followees(user_id) do
    {count_followers(user_id), count_followees(user_id)}
  end

  def count_followers(user_id) do
    # Query to count the number of followers

    Repo.aggregate(
      from(f in Follow,
        where: f.followee_id == ^user_id
      ),
      :count,
      :id
    )
  end

  def count_followees(user_id) do
    # Query to count the number of followees

    Repo.aggregate(
      from(f in Follow,
        where: f.user_id == ^user_id
      ),
      :count,
      :id
    )
  end

  def get_all_followees(user_id) do
    Repo.all(
      from follow in Follow,
        where: follow.user_id == ^user_id,
        select: follow,
        order_by: [desc: follow.inserted_at]
    )
  end

  # get all followers of a user
  def get_all_followers(user_id) do
    Repo.all(
      from follow in Follow,
        where: follow.followee_id == ^user_id,
        select: follow,
        order_by: [desc: follow.inserted_at]
    )
  end
end
