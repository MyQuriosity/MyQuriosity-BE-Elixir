defmodule Core.DataCase do
  @moduledoc """
  # TODO: Write proper moduledoc
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Core.DataCase
      import TenantData.Support.Factory
    end
  end

  setup _tags do
    if Triplex.exists?("test_sub_domain") == false do
      Triplex.create("test_sub_domain", TenantData.Repo)
      Triplex.migrate("test_sub_domain", TenantData.Repo)
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
