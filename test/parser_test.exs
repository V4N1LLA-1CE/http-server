defmodule ParserTest do
  use ExUnit.Case
  doctest HttpServer.Parser

  alias HttpServer.Parser

  test "parses a list of header fields into a map" do
    header_lines = [
      "Host: example.com",
      "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
      "Accept: application/json, text/plain, */*",
      "Accept-Language: en-US,en;q=0.9",
      "Accept-Encoding: gzip, deflate, br",
      "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "Content-Type: application/json",
      "Set-Cookie: session_id=xyz789; HttpOnly; Secure; SameSite=Strict"
    ]

    headers = Parser.parse_headers(header_lines, %{})

    assert headers == %{
             "Host" => "example.com",
             "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
             "Accept" => "application/json, text/plain, */*",
             "Accept-Language" => "en-US,en;q=0.9",
             "Accept-Encoding" => "gzip, deflate, br",
             "Authorization" => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
             "Content-Type" => "application/json",
             "Set-Cookie" => "session_id=xyz789; HttpOnly; Secure; SameSite=Strict"
           }
  end
end
