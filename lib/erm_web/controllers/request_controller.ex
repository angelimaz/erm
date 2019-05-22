defmodule ErmWeb.RequestController do
  use ErmWeb, :controller
  alias Phoenix.LiveView


  #plug Guardian.Permissions.Bitwise, [ensure: %{dashboard: [:all]}] when action in [:index]

  def index(conn, _params) do
    # case Guardian.Plug.current_resource(conn) do
    #   nil ->
    #     render(conn, "index.html")
    #   entity ->
    #     conn
    #     |> assign(:auth_token, generate_auth_token(conn))
    #     |> assign(:game_name, "magic-game")
    #     |> render(role_to_view(entity.roles))
    # end
    IO.inspect(conn)
    LiveView.Controller.live_render(conn, ErmWeb.RequestLive, session: %{current_user: Guardian.Plug.current_resource(conn)})
  end

  defp generate_auth_token(conn) do
    current_user = get_session(conn, :user_id)
    #Phoenix.Token.sign(conn, "user auth", current_user)
    current_user |> IO.inspect()
  end
end
