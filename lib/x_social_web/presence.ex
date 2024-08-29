defmodule XSocialWeb.Presence do
  @moduledoc """
  The presence module for the XSocialWeb.
  """
  use Phoenix.Presence,
    otp_app: :x_social,
    pubsub_server: XSocial.PubSub
end
