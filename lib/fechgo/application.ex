defmodule Fechgo.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Fechgo.Repo, []),
      # Start the endpoint when the application starts
      supervisor(FechgoWeb.Endpoint, []),
      # Start your own worker by calling: Fechgo.Worker.start_link(arg1, arg2, arg3)
      # worker(Fechgo.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fechgo.Supervisor]
    Supervisor.start_link(children, opts)
    |> after_start()
  end

  defp after_start({:ok, _} = result) do
    if Application.get_env(:fechgo, :uploads_path) |> is_nil() do
      path =
        Application.app_dir(:fechgo, "priv")
        |> Path.join("static/uploads")

      Application.put_env(:fechgo, :uploads_path, path)
    end

    result
  end
  defp after_start(result), do: result

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FechgoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
