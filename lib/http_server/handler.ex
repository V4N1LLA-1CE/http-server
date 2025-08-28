defmodule HttpServer.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(conv) do
    [method, path, _http_version] =
      conv
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def route(conv) do
    conv |> route(conv.method, conv.path)
  end

  def log(conv), do: IO.inspect(conv)

  def route(conv, "GET", "/hello") do
    %{conv | resp_body: "hello world!"}
  end

  def route(conv, method, path) do
    %{conv | resp_body: "No endpoints for #{method} #{path}"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

sample_request = """
GET /hello HTTP/1.1
HOST: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = HttpServer.Handler.handle(sample_request)
IO.puts(response)
