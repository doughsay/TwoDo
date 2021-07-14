defmodule TwoDo.Repo do
  use Ecto.Repo,
    otp_app: :two_do,
    adapter: Ecto.Adapters.Postgres
end
