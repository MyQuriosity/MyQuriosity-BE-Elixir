defmodule Ecto.SoftDelete.Repo do
  @moduledoc """
  Adds soft deactivate functions to an repository.

      defmodule Repo do
        use Ecto.Repo,
          otp_app: :my_app,
          adapter: Ecto.Adapters.Postgres
        use Ecto.Softdeactivate.Repo
      end

  """

  @doc """
  Soft deactivates all entries matching the given query.

  It returns a tuple containing the number of entries and any returned
  result as second element. The second element is `nil` by default
  unless a `select` is supplied in the update query.

  ## Examples

      MyRepo.soft_delete_all(Post)
      from(p in Post, where: p.id < 10) |> MyRepo.soft_delete_all()

  """
  @callback soft_deactivate_all(queryable :: Ecto.Queryable.t()) :: {integer, nil | [term]}

  @doc """
  Soft deactivates a struct.
  Updates the `deactivated_at` field with the current datetime in UTC.
  It returns `{:ok, struct}` if the struct has been successfully
  soft deactivated or `{:error, changeset}` if there was a validation
  or a known constraint error.

  ## Examples

      post = MyRepo.get!(Post, 42)
      case MyRepo.soft_delete post do
        {:ok, struct}       -> # Soft deactivated with success
        {:error, changeset} -> # Something went wrong
      end

  """
  @callback soft_deactivate(struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t()) ::
              {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @callback soft_delete(struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t()) ::
              {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Same as `c:soft_deactivate/1` but returns the struct or raises if the changeset is invalid.
  """
  @callback soft_deactivate!(struct_or_changeset :: Ecto.Schema.t() | Ecto.Changeset.t()) ::
              Ecto.Schema.t()

  defmacro __using__(_opts) do
    quote do
      import Ecto.Query

      def soft_deactivate_all(queryable) do
        update_all(queryable,
          set: [deactivated_at: DateTime.truncate(DateTime.utc_now(), :second)]
        )
      end

      def soft_deactivate(struct_or_changeset) do
        struct_or_changeset
        |> Ecto.Changeset.change(deactivated_at: DateTime.truncate(DateTime.utc_now(), :second))
        |> update()
      end

      def soft_deactivate!(struct_or_changeset) do
        struct_or_changeset
        |> Ecto.Changeset.change(deactivated_at: DateTime.truncate(DateTime.utc_now(), :second))
        |> update!()
      end

      def soft_delete(struct_or_changeset) do
        struct_or_changeset
        |> Ecto.Changeset.change(deactivated_at: DateTime.truncate(DateTime.utc_now(), :second))
        |> update()
      end

      def soft_delete!(struct_or_changeset) do
        struct_or_changeset
        |> Ecto.Changeset.change(deactivated_at: DateTime.truncate(DateTime.utc_now(), :second))
        |> update!()
      end

      @doc """
      Overrides all query operations to exclude soft deactivated records
      if the schema in the from clause has a deactivated_at column
      NOTE: will not exclude soft deactivated records if :with_deactivated option passed as true
      """
      def prepare_query(_operation, query, opts) do
        schema_module = get_schema_module_from_query(query)
        fields = if schema_module, do: schema_module.__schema__(:fields), else: []
        soft_deactivateable? = Enum.member?(fields, :deactivated_at)

        if has_include_deactivated_at_clause?(query) || opts[:with_deactivated] ||
             !soft_deactivateable? do
          {query, opts}
        else
          # TODO: uncomment this after properly implementing soft delete
          # query = from(x in query, where: is_nil(x.deactivated_at))
          {query, opts}
        end
      end

      # Checks the query to see if it contains a where not is_nil(deactivated_at)
      # if it does, we want to be sure that we don't exclude soft deactivated records
      defp has_include_deactivated_at_clause?(%Ecto.Query{wheres: wheres}) do
        Enum.any?(wheres, fn %{expr: expr} ->
          expr ==
            {:not, [], [{:is_nil, [], [{{:., [], [{:&, [], [0]}, :deactivated_at]}, [], []}]}]}
        end)
      end

      defp get_schema_module_from_query(%Ecto.Query{from: %{source: {_name, module}}}) do
        module
      end

      defp get_schema_module_from_query(_), do: nil
    end
  end
end
