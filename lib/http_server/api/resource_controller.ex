defmodule HttpServer.Api.ResourceController do
  def index(conv) do
    json =
      HttpServer.ResourceService.list_resources()
      |> Jason.encode!()

    %{conv | status: 200, content_type: "application/json", resp_body: json}
  end
end
