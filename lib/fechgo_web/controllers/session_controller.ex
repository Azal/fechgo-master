defmodule FechgoWeb.SessionController do
  use FechgoWeb, :controller
  alias Fechgo.Authentication.BasicAuth

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case BasicAuth.login_by_username_and_pass(conn, user, pass, repo: Fechgo.Repo) do
    {:ok, conn} ->
      conn
      |> put_flash(:info, "Welcome back!")
      |> redirect(to: page_path(conn, :index))
    {:error, _reason, conn} ->
      conn
      |> put_flash(:error, "Invalid username/password combination")
      |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> BasicAuth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
