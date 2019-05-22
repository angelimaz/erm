defmodule Erm.Sap.Vendor do
  # notice there is no `use Tesla`

  @url "http://s4hanaides:8001/sap/opu/odata/sap/zportal_srv/"
  @auth Base.encode64("aimaz:Nasya1317#")


  def get(client) do
    Tesla.get(client, "/BPs?$format=json")
  end

  def post(client, body) do
    Tesla.post(client, "/BPs?$format=json", body)
  end

  # build dynamic client based on runtime arguments
  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, @url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, request_headers(@auth, token)},
      Erm.Sap.Middleware
    ]

    Tesla.client(middleware)
  end

  defp request_headers(auth, token) do
    [
      Authorization: "Basic #{auth}",
      Accept: "Application/json; Charset=utf-8",
      "x-csrf-token": "#{token}"
    ]
  end
end
