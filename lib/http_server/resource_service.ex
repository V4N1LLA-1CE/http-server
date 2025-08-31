defmodule HttpServer.ResourceService do
  alias HttpServer.Resource

  def list_resources do
    [
      %Resource{
        id: 1,
        resource: "eyZBwcm224mf2pf2og2usasgdoajf?dfasjg#r44dpsghsagpPGIhwpi2oabvabeovijg2ogn2nda",
        type: "bearer",
        valid: false
      },
      %Resource{
        id: 2,
        resource: "a05d4442b3b4d63051ebe5fe9ef43ea66e176d6e2cfa34f8dfdecafaa9a27525",
        type: "somerandomsecretencoded",
        valid: true
      },
      %Resource{
        id: 3,
        resource: "password123",
        type: "plaintext",
        valid: false
      },
      %Resource{
        id: 4,
        resource:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ",
        type: "bearer",
        valid: true
      },
      %Resource{
        id: 5,
        resource: "b7f2c8e1a9d4f6h3k8m2p5r7t9w1x4z6a2c5e8f1h4j7m9p2r5t8w1x4z7a3c6e9",
        type: "api_key",
        valid: true
      }
    ]
  end

  def get_resource(id) when is_integer(id) do
    Enum.find(list_resources(), fn r -> r.id == id end)
  end

  def get_resource(id) when is_binary(id) do
    id |> String.to_integer() |> get_resource()
  end
end
