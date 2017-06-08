defmodule TwitterGrapher.Router do
  use TwitterGrapher.Web, :router

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

  scope "/", TwitterGrapher do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    
    get "/store-twitter-relations", TwitterController, :new
    post "/store-twitter-relations", TwitterController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", TwitterGrapher do
  #   pipe_through :api
  # end
end
