defmodule HttpServer.ResourceController do
  alias HttpServer.ResourceService
  alias HttpServer.Resource

  @templates_path Path.expand("../templates", __DIR__)

  def render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end

  def index(conv) do
    resources =
      ResourceService.list_resources()
      |> Enum.sort(fn r1, r2 -> Resource.order_asc_by_id(r1, r2) end)

    render(conv, "index.eex", resources: resources)
  end

  def show(conv, %{"id" => id}) do
    resource = ResourceService.get_resource(id)

    render(conv, "show.eex", resource: resource)
  end

  def create(conv, %{"resource" => resource, "type" => type}) do
    %{
      conv
      | status: 201,
        resp_body: "New resource! Created a #{resource} of type #{type}"
    }
  end
end
