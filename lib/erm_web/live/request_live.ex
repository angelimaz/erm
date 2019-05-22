defmodule ErmWeb.RequestLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Erm.Entities.Approval
  alias Erm.Entities.Request

  @topic "requests"
  @url "http://s4hanaides:8001/sap/opu/odata/sap/zportal_srv/BPs?$format=json"
  @auth Base.encode64("aimaz:test")
  @middleware Erm.Sap.Middleware

  def render(assigns) do
    IO.puts("render/1")
    IO.inspect(assigns)
    ErmWeb.RequestView.render("index.html", assigns)
  end

  def mount(session, socket) do
    IO.puts("mount/2")

    changeset =
      %Request{}
      |> Erm.Entities.Request.changeset(%{})
      |> Map.put(:action, :insert)

    # url = "http://s4hanaides:8001/sap/opu/odata/sap/zportal_srv/BPs?$format=json"
    # auth = Base.encode64("aimaz:Nasya1317#")

    # headers = [
    #   Authorization: "Basic #{auth}",
    #   Accept: "Application/json; Charset=utf-8",
    #   "x-csrf-token": "Fetch"
    # ]

    # token =
    #   case HTTPoison.get(url, headers) do
    #     {:ok, %HTTPoison.Response{status_code: 200, headers: [{"x-csrf-token", token}]}} ->
    #       IO.puts("got token")
    #       token

    #     {:ok, %HTTPoison.Response{status_code: 200, headers: headers}} ->
    #       IO.inspect(extract_token_from_header(headers))

    #     other ->
    #       IO.puts("no 200")
    #       IO.inspect(other)
    #       ""
    #   end

    # ErmWeb.Endpoint.subscribe(@topic)

    {:ok,
     assign(socket, %{
       status: "New",
       current_user: session.current_user,
       changeset: changeset,
       token: ""
     })}
  end

  def handle_event("save", value, socket) do
    # do the deploy process
    IO.puts("save button")
    IO.inspect(socket.assigns)

    request_headers = request_headers(@auth, "Fetch")
    IO.puts("get request headers:")
    IO.inspect(request_headers)

    # client = Erm.Sap.Vendor.client("Fetch")


    # {:ok, response} = Erm.Sap.Vendor.get(client)

    # IO.inspect response

    #   body = %{
    #       partner: "",
    #       name: "",
    #       address: "",
    #       country: "ES",
    #       postcode: "12345",
    #       email: ""
    #     }


    #     {:ok, response} = Erm.Sap.Vendor.post(client, body)
    #     IO.puts "post"
    #     IO.inspect response

    # # env = Map.replace(response, :method, :post)
    # # |> Tesla.put_body(payload)

    # # {:ok, out} = Tesla.run(env, [], [])
    # # IO.puts "out"
    # # IO.inspect out
    # # IO.puts "out:body"
    # # IO.inspect out.body



    # IO.inspect extract_token_from_header(response.headers)

    case HTTPoison.get(@url, request_headers) do
      %HTTPotion.Response{status_code: 200, headers: [{"x-csrf-token", token}], body: _body} ->
        IO.puts("got token")
        token

      {:ok, %HTTPoison.Response{status_code: 200, headers: headers, body: body}} ->
        IO.puts("200 with headers")
        IO.puts("body: ")
        IO.inspect(body)
        IO.puts("headers")
        IO.inspect(headers)

        token = extract_token_from_header(headers)


        payload = %{
          partner: "",
          name: "",
          address: "",
          country: "ES",
          postcode: "12345",
          email1: ""
        }

        body = Jason.encode!(payload)

        body =  "{\"Address\":\"\",\"Country\":\"ES\",\"Email1\":\"\",\"Name\":\"\",\"Partner\":\"\",\"Postcode\":\"12345\"}"
        IO.inspect body
        # token = "Fetch"
        # extract_cookie_from_header(headers)  ++
        request_headers =
          request_headers_base(@auth) ++
            filter_token_from_headers(headers)

        IO.puts "extratc_cookie_from_header"
        {_k, value} = extract_cookie_from_header(headers) |> List.last()






        return = HTTPoison.post(@url, body, request_headers,  hackney: [cookie: value])
        IO.inspect(return)



      other ->
        IO.puts("no 200")
        IO.inspect(other)
        ""
    end

    {:noreply, assign(socket, status: "In Process")}
  end

  def handle_event("add_step", _value, socket) do
    # do the deploy process
    IO.puts("send button")
    IO.inspect(socket.assigns)

    {:noreply,
     assign(socket, %{
       status: "Add step",
       steps:
         socket.assigns.steps ++
           [{length(socket.assigns.steps), Erm.Flows.change_step(%Erm.Flows.Step{})}]
     })}
  end

  def handle_event("validate", %{"approval" => params}, socket) do
    IO.puts("Validating ...")
    IO.inspect(params)

    changeset =
      %Approval{}
      |> Erm.Entities.Approval.changeset(params)
      |> Map.put(:action, :insert)
      |> IO.inspect()

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("validate_1", %{"flow" => params}, socket) do
    IO.puts("Validating 1 ...")
    IO.inspect(params)

    changeset =
      %Erm.Flows.Flow{}
      |> Erm.Flows.Flow.changeset(params)
      |> Map.put(:action, :insert)
      |> IO.inspect()

    {:noreply, assign(socket, changeset_1: changeset)}
  end

  def handle_event("validate_step", step = all, socket) do
    IO.puts("Validating step ...")
    IO.inspect(all)

    step_key =
      step
      |> Map.keys()
      |> List.last()
      |> IO.inspect()

    step_index =
      step_key
      |> get_step_index()
      |> IO.inspect()

    params =
      step[step_key]
      |> IO.inspect()

    changeset =
      %Erm.Flows.Step{}
      |> Erm.Flows.Step.changeset(params)
      |> Map.put(:action, :insert)
      |> IO.inspect()

    new_steps =
      List.replace_at(socket.assigns.steps, step_index, {step_index, changeset})
      |> IO.inspect()

    {:noreply,
     assign(socket, %{
       changeset_1: changeset,
       steps: new_steps
     })}
  end

  defp get_step_index("step_" <> index) do
    {index, ""} = Integer.parse(index)
    index
  end

  def handle_event(event, params, socket) do
    IO.puts("handle_event #{event}")

    IO.inspect(params)

    {:noreply, socket}
  end

  def test(f) do
    # IO.inspect(f)
    content_tag :div do
      [
        label(f, :name, "key_placeholder"),
        text_input(f, :name)
      ]
    end
  end

  defp flow(f) do
    # IO.inspect(f)
    content_tag :div do
      [
        label(f, :title, "flow"),
        text_input(f, :title)
      ]
    end
  end

  defp extract_token_from_header(%HTTPotion.Headers{
         hdrs: %{
           "x-csrf-token" => token
         }
       }) do
    token
  end

  defp extract_token_from_header(%HTTPotion.Headers{hdrs: header}) do
    IO.puts("extract token from header")

    case Enum.find(header, fn {k, _v} ->
           k == "x-csrf-token"
         end) do
      nil ->
        ""

      {_key, token} ->
        token
    end
  end

  defp extract_token_from_header(header) do
    IO.puts("extract token from header")

    case Enum.find(header, fn {k, _v} ->
           k == "x-csrf-token"
         end) do
      nil ->
        ""

      {_key, token} ->
        token
    end
  end

  defp extract_cookie_from_header(%HTTPotion.Headers{hdrs: header}) do
    Enum.filter(header, fn {k, _v} ->
      k == "set-cookie"
    end)
  end

  defp extract_cookie_from_header(header) do
    Enum.filter(header, fn {k, _v} ->
      k == "set-cookie"
    end)
  end

  defp filter_token_from_headers(header) do
    Enum.filter(header, fn {k, _v} ->
      k == "x-csrf-token"
    end)
    |> IO.inspect()
  end


  defp filter_token_from_headers(%HTTPotion.Headers{hdrs: header}) do
    Enum.filter(header, fn {k, _v} ->
      k == "x-csrf-token"
    end)
    |> IO.inspect()
  end

  defp request_headers(auth, token) do
    [
      Authorization: "Basic #{auth}",
      Accept: "Application/json; Charset=utf-8",
      "x-csrf-token": "#{token}"
    ]
  end

  defp request_headers_base(auth) do
    [
      Authorization: "Basic #{auth}",
      Accept: "Application/json; Charset=utf-8"
    ]
  end
end
