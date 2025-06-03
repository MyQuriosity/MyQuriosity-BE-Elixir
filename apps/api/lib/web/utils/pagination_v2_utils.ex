defmodule Api.Utils.PaginationV2Utils do
  @moduledoc """
  PaginationUtils keeps the general pagination
  context in it.
  All other apps can use this for pagination purposes.
  """
  use FatEcto.Pagination.V2Paginator,
    default_limit: 10,
    repo: Data.Repo,
    max_limit: 100

  def paginated(query, params) do
    query =
      from(q in query,
        where: is_nil(q.deactivated_at)
      )

    params = [offset: params["skip"], limit: params["limit"]]
    paginate(query, params)
  end
end
