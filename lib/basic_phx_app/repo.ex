defmodule BasicPhxApp.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :basic_phx_app,
    adapter: Ecto.Adapters.Postgres
end
