defmodule TwitterGrapher.PageController do
  use TwitterGrapher.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
