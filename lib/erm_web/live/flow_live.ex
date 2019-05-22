defmodule ErmWeb.FlowLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Erm.Flows.Step
  alias ErmWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <div class="">
      <div>
        <div>
          <button phx-click="save_flow">Save Flow</button>
        </div>

        Status: <%= @status %>

      </div>
      <%= form_for @changeset, "#", [phx_change: :validate, phx_submit: :save], fn f -> %>
        <div class="field is-horizontal">
          <%= label f, :name %>
          <%= text_input f, :name %>
          <%= label f, :process %>
          <%= text_input f, :process %>
          <%= label f, :type %>
          <%= text_input f, :type %>
        </div>
      <% end %>
      Steps:
      <div>
      <button phx-click="add_step">Add Step</button>
    </div>
    <%= for {index, step} <- @steps do %>
        <%= form_for step, "#", [as: "step_#{inspect(index)}", phx_change: :validate_step, phx_submit: :save_step], fn p -> %>
         <div class="field is-horizontal">

          <%= label p, :name %>
          <%= text_input p, :name %>
          <%= label p, :type %>
          <%= text_input p, :type %>
          <%= label p, :value %>
          <%= text_input p, :value %>
          <%= label p, :next_step %>
          <%= text_input p, :next_step %>
        </div>
        <% end %>
    <% end %>


    </div>
    """
  end

  def mount(_session, socket) do
    #ErmWeb.Endpoint.subscribe(@topic)

    {:ok,
     assign(socket, %{
       status: "New",
       steps: [],
       changeset: Erm.Flows.change_flow(%Erm.Flows.Flow{})
     })}
  end

  def handle_event("save_flow", _value, socket) do
    new_changeset =
      socket.assigns.changeset
      |> Erm.Flows.Flow.add_steps_to_changeset(socket.assigns.steps)

    case Erm.Repo.insert(new_changeset) do
      {:ok, flow} ->
        {:stop,
         socket
         |> put_flash(:info, "flow created")
         |> redirect(to: Routes.flow_path(socket, :show, flow))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("add_step", _value, socket) do
    IO.puts("add step button")
    IO.inspect(socket.assigns)

    {:noreply,
     assign(socket, %{
       status: "Add step",
       steps:
         socket.assigns.steps ++
           [{length(socket.assigns.steps), Erm.Flows.change_step(%Step{})}]
     })}
  end

  def handle_event("validate", %{"flow" => params}, socket) do
    IO.puts("Validating flow ...")
    IO.inspect(params)

    changeset =
      %Erm.Flows.Flow{}
      |> Erm.Flows.Flow.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("validate_step", step = all, socket) do
    IO.puts("Validating step ...")
    IO.inspect(all)

    step_key =
      step
      |> Map.keys()
      |> List.last()

    step_index =
      step_key
      |> get_step_index()

    params =
      step[step_key]

    step_changeset =
      %Erm.Flows.Step{}
      |> Erm.Flows.Step.changeset(params)
      |> Map.put(:action, :insert)

    new_steps =
      List.replace_at(socket.assigns.steps, step_index, {step_index, step_changeset})

    {:noreply,
     assign(socket, %{
       steps: new_steps
     })}
  end

  def handle_event(event, params, socket) do
    IO.puts("handle_event #{event}")

    IO.inspect(params)

    {:noreply, socket}
  end

  defp get_step_index("step_" <> index) do
    {index, ""} = Integer.parse(index)
    index
  end
end
