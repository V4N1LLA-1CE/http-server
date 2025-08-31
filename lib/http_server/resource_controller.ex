defmodule HttpServer.ResourceController do
  alias HttpServer.ResourceService
  alias HttpServer.Resource

  defp resource_html(r) do
    "<li>#{r.resource} - #{r.type} - #{r.valid}</li>"
  end

  def index(conv) do
    items =
      ResourceService.list_resources()
      |> Enum.filter(fn r -> Resource.is_valid(r) end)
      |> Enum.sort(fn r1, r2 -> Resource.order_asc_by_id(r1, r2) end)
      |> Enum.map(fn r -> resource_html(r) end)
      |> Enum.join()

    %{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    resource = ResourceService.get_resource(id)
    %{conv | status: 200, resp_body: "<h1>#{id} - #{resource.valid}</h1>"}
  end

  def create(conv, %{"resource" => resource, "type" => type}) do
    %{
      conv
      | status: 201,
        resp_body: "New resource! Created a #{resource} of type #{type}"
    }
  end
end
