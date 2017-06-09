defmodule Headsup.Web.Router do
  use Headsup.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Headsup.Web do
    pipe_through :browser # Use the default browser stack

    get "/", SubscriptionController, :new
    post "/", SubscriptionController, :create
    resources "/players", PlayerController
    get "/thanks", SubscriptionController, :thanks
    get "/matches", SubscriptionController, :live_matches
    get "/:uuid", SubscriptionController, :edit
    put "/:uuid", SubscriptionController, :update
    put "/:uuid/delete", SubscriptionController, :delete
    get "/:uuid/players", SubscriptionController, :players

    #resources "/subscriptions", SubscriptionController
    resources "/player_subscriptions", PlayerSubscriptionController

  end

  # Other scopes may use custom stacks.
  # scope "/api", Headsup.Web do
  #   pipe_through :api
  # end
end
