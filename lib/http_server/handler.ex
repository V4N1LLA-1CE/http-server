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

    %{method: method, path: path, resp_body: "", status: nil}
  end

  def log(conv), do: IO.inspect(conv)

  def route(%{method: "GET", path: "/hello"} = conv) do
    %{conv | resp_body: "hello world!", status: 200}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    file =
      Path.expand("../pages", __DIR__)
      |> Path.join("about.html")

    case File.read(file) do
      {:ok, content} ->
        %{conv | status: 200, resp_body: content}

      {:error, :enoent} ->
        %{conv | status: 404, resp_body: "Page does not exist or cannot be found"}

      {:error, reason} ->
        %{conv | status: 500, resp_body: "File error: #{reason}"}
    end
  end

  def route(%{method: "GET", path: "/resource" <> id} = conv) do
    %{conv | status: 200, resp_body: "Resource number #{id}"}
  end

  def route(%{method: method, path: path} = conv) do
    %{conv | status: 404, resp_body: "No endpoint for #{method} #{path}"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

sample_request = """
GET /about HTTP/1.1
HOST: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = HttpServer.Handler.handle(sample_request)
IO.puts(response)
