defmodule XSocial.Relation do
  @moduledoc """
  The Relation context.
  """

  import Ecto.Query, warn: false
  alias XSocial.Repo

  alias XSocial.Relation.Follow
  alias XSocial.Auth.User

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

  def get_all_followers(user_id) do
    Repo.all(
      from follow in Follow,
        join: follower in User,
        on: follower.id == follow.followee_id,
        where: follow.followee_id == ^user_id,
        order_by: [desc: follow.inserted_at],
        select: follower
    )
  end

  def get_all_following(user_id) do
    Repo.all(
      from follow in Follow,
        join: followee in User,
        on: followee.id == follow.followee_id,
        where: follow.user_id == ^user_id,
        order_by: [desc: follow.inserted_at],
        select: followee
    )
  end
end
