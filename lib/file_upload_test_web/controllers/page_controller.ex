defmodule FileUploadTestWeb.PageController do
  use FileUploadTestWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
