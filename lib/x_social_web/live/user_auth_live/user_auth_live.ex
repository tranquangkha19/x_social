defmodule XSocialWeb.UserAuthLive do
  import Phoenix.LiveView
  import Phoenix.Component
  alias XSocial.Auth
  alias XSocial.Relation

  def on_mount(:ensure_authorized, _params, %{"user_id" => user_id} = _session, socket) do
    with user when not is_nil(user) <- Auth.get_user(user_id),
         following_list <- Relation.get_all_following_ids(user_id) do
      following_map = Enum.into(following_list, %{}, fn x -> {x, true} end)

      socket =
        socket
        |> assign(:current_user, user)
        |> assign(:current_user_follow_map, following_map)

      {:cont, socket}
    else
      _ ->
        {:halt, redirect(socket, to: "/login")}
    end
  end

  def on_mount(:ensure_authorized, _params, _session, socket) do
    {:halt, redirect(socket, to: "/login")}
  end
end
