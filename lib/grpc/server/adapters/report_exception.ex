defmodule GRPC.Server.Adapters.ReportException do
  @moduledoc """
  Exception raised by server adapter, meant to be used as part of metadata `crash_report`
  """

  defexception [:kind, :reason, :stack, :adapter_extra]

  def new(adapter_extra, %{__exception__: _} = exception, stack \\ [], kind \\ :error) do
    exception(kind: kind, reason: exception, stack: stack, adapter_extra: adapter_extra)
  end

  def message(%__MODULE__{adapter_extra: [{:req, req}], kind: kind, reason: reason, stack: stack}) do
    # Cowboy adapter message builder
    path = :cowboy_req.path(req)
    "Exception raised while handling #{path}:\n" <> Exception.format_banner(kind, reason, stack)
  end
end
