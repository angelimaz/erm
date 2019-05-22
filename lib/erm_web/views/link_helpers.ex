defmodule ErmWeb.LinkHelpers do
  use Phoenix.HTML

  def modal_link(opts, do: contents) when is_list(opts) do
    modal_link(contents, opts)
  end

  def modal_link(text, opts) do
    to = Keyword.get(opts, :to)
    opts =
      opts
      |> Keyword.put(:"data-modal", to)
      |> Keyword.put(:to, "#")
    link(text, opts)
  end
end
