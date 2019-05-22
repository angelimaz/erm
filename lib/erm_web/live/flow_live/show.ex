defmodule ErmWeb.FlowLive.Show do
  use Phoenix.LiveView

  use Phoenix.HTML

  alias Erm.Flows

  alias Phoenix.LiveView.Socket

  def render(assigns) do
    ~L"""

    <h2>Show Flow</h2>

    <ul>

      <li><b>Name:</b> <%= @flow.name %></li>

      <li><b>Type:</b> <%= @flow.type %></li>

      <li><b>Process:</b> <%= @flow.process %></li>

    </ul>

    """
  end

  def mount(%{path_params: %{"id" => id}}, socket) do
    #if connected?(socket), do: Demo.Accounts.subscribe(id)

    {:ok, fetch(assign(socket, id: id))}
  end

  defp fetch(%Socket{assigns: %{id: id}} = socket) do
    assign(socket, flow: Flows.get_flow!(id))
  end

  # def handle_info({Accounts, [:user, :updated], _}, socket) do
  #   {:noreply, fetch(socket)}
  # end

  # def handle_info({Accounts, [:user, :deleted], _}, socket) do
  #   {:stop,
  #    socket
  #    |> put_flash(:error, "This user has been deleted from the system")
  #    |> redirect(to: Routes.live_path(socket, UserLive.Index))}
  # end
end
