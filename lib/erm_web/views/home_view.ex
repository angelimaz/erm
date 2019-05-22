defmodule ErmWeb.HomeView do
  use ErmWeb, :view

  def ws_url do
    System.get_env("WS_URL") || ErmWeb.Endpoint.config(:ws_url)
  end
end
