defmodule XSocial.Repo do
  use Ecto.Repo,
    otp_app: :x_social,
    adapter: Ecto.Adapters.Postgres
end
