defmodule Pdfstripper2.Router do
  use Pdfstripper2.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    #    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pdfstripper2 do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/process", PageController, :process
  end

end
