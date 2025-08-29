defmodule HttpServer.Parser do
  alias HttpServer.Conv

  def parse(conv) do
    [method, path, _http_version] =
      conv
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{
      method: method,
      path: path
    }
  end
end
