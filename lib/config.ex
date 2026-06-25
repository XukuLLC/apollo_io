defmodule ApolloIo.Config do
  @moduledoc false

  # Resolution order:
  #   1. `config :apollo_io, base_url: ...` (explicit override)
  #   2. localhost mock when running the test suite
  #   3. the live API
  #
  # `Mix` is not available in a packaged release, where a bare `Mix.env/0` call
  # raises, so guard it with `function_exported?/3`. Behavior is unchanged
  # anywhere Mix is present (dev/test).
  def base_url do
    Application.get_env(:apollo_io, :base_url) || default_base_url()
  end

  defp default_base_url do
    if function_exported?(Mix, :env, 0) and Mix.env() == :test do
      "http://localhost:12345"
    else
      "https://api.apollo.io"
    end
  end
end
