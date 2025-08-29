defmodule HttpServer.Parser do
  alias HttpServer.Conv

  def parse(request) do
    [top, param_string] = String.split(request, "\n\n")
    [start | _header] = top |> String.split("\n")

    params = parse_params(param_string)

    [method, path, _http_version] = start |> String.split(" ")

    %Conv{
      method: method,
      path: path,
      params: params
    }
  end

  def parse_params(param_string) do
    param_string
    |> String.trim()
    |> URI.decode_query()
  end
end
