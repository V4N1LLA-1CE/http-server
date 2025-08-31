defmodule HttpServer.Handler do
  alias HttpServer.Conv
  alias HttpServer.ResourceController

  @moduledoc """
  Handles HTTP requests.
  """

  @pages_path Path.expand("../pages", __DIR__)

  import HttpServer.Plugins, only: [track: 1, log: 1]
  import HttpServer.Parser, only: [parse: 1]

  @doc """
  Transforms the request into a response.
  """
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/hello"} = conv) do
    %{conv | resp_body: "hello world!", status: 200}
  end

  def route(%Conv{method: "GET", path: "/resource"} = conv) do
    ResourceController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/resource"} = conv) do
    HttpServer.Api.ResourceController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/resource/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    ResourceController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/resource"} = conv) do
    ResourceController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{method: method, path: path} = conv) do
    %{conv | status: 404, resp_body: "No endpoint for #{method} #{path}"}
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "Page does not exist or cannot be found"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end

# request = """
# POST /resource HTTP/1.1
# HOST: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 21
#
# resource=supersecret&type=plaintext
# """

request = """
GET /api/resource HTTP/1.1\r
HOST: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
Content-Type: application/x-www-form-urlencoded\r
Content-Length: 21\r
\r
"""

# request = """
# GET /resource/3 HTTP/1.1\r
# HOST: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*\r
# Content-Type: application/x-www-form-urlencoded\r
# \r
# """

response = HttpServer.Handler.handle(request)

IO.puts(response)
