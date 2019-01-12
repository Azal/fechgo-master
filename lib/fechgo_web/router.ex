defmodule FechgoWeb.Router do
  use FechgoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Fechgo.Authentication.BasicAuth, repo: Fechgo.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FechgoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/head-to-head", PlayerController, :compare
    get "/head-to-head/:player_id/:opponent_id", PlayerController, :show_compare
    resources "/players", PlayerController, only: [:index, :show]
    resources "/tournaments", TournamentController, only: [:index, :show]
    resources "/session", SessionController, only: [:new, :create, :delete]
  end

  scope "/admin", FechgoWeb do
    pipe_through [:browser, :authenticate_user]

    get "/", PageController, :admin_index
    get "/players_import", PlayerController, :new_file_import
    post "/players_import", PlayerController, :create_players_from_file
    resources "/tournaments", TournamentController, only: [:new, :create, :edit, :update, :delete]
    resources "/players", PlayerController, only: [:new, :create, :edit, :update, :delete]
    resources "/tournament_types", TournamentTypeController
    resources "/users", UserController
    # Still not using these controllers
    resources "/clubs", ClubController
    resources "/rounds", RoundController
    resources "/games", GameController
    resources "/points_history", PointHistoryController
  end

  # Other scopes may use custom stacks.
  # scope "/api", FechgoWeb do
  #   pipe_through :api
  # end
end
