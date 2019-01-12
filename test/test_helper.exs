ExUnit.start()

Code.load_file("test/seed.exs")

Ecto.Adapters.SQL.Sandbox.mode(Fechgo.Repo, :manual)

