defmodule PhoenixDatadogWeb.PageController do
  use PhoenixDatadogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
