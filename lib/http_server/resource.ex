defmodule HttpServer.Resource do
  @derive {Jason.Encoder, only: [:id, :resource, :type, :valid]}
  defstruct id: nil, resource: "", type: "", valid: false

  def is_valid(r) do
    r.valid == true
  end

  def order_asc_by_id(r1, r2) do
    r1.id <= r2.id
  end
end
