defmodule ErmWeb.Router do
  use ErmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Erm.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end



  scope "/", ErmWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    post "/logout", AuthController, :logout
    resources "/auths", AuthentificationController
    resources "/partners", PartnerController, only: [:new, :create]
  end

  # Definitely logged in scope
  scope "/", ErmWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/home", HomeController, :index
    get "/map", MapController, :index
    resources "/entities", EntityController
    resources "/relations", RelationController
    resources "/activities", ActivityController
    resources "/approvals", ApprovalController
    resources "/roles", RoleController
    resources "/tags", TagController
    #live "/flows/:id", FlowLive.Show
    resources "/flows", FlowController
    get "/requests", RequestController, :index

  end

  scope "/auth", ErmWeb do
    pipe_through [:browser, :auth]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/identity/callback", AuthController, :identity_callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", ErmWeb do
  #   pipe_through :api
  # end
end
