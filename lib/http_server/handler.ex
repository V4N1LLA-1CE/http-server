defmodule HttpServer.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(conv) do
    # TODO: parse request string into map
  end

  def route(conv) do
    # TODO: what does this specific route do? change response body?
  end

  def format_response(conv) do
    # TODO: format response to a http response string
  end
end

sample_request = """
GET /hello HTTP/1.1
HOST: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

sample_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Hello World!
"""
