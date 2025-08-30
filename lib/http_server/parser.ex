defmodule HttpServer.Parser do
  alias HttpServer.Conv

  def parse(request) do
    [top, param_string] = String.split(request, "\n\n")
    [start | header] = top |> String.split("\n")

    headers = parse_headers(header, %{})
    params = parse_params(headers["Content-Type"], param_string)

    [method, path, _http_version] = start |> String.split(" ")

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_params("application/x-www-form-urlencoded", param_string) do
    param_string
    |> String.trim()
    |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head | tail], headers) do
    [key, value] = head |> String.split(": ")

    headers = Map.put(headers, key, value)

    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers
end
