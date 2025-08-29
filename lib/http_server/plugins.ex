defmodule HttpServer.Plugins do
  alias HttpServer.Conv

  @doc "Logs 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts("Warning: #{path} cannot be found")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect(conv)
end
