defmodule QuizGenerator.ValidationHelper do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  import Phoenix.Controller
  import Plug.Conn
  alias QuizGenerator.Repo

  @spec return(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def return(conn, params) do
    type = hd(params)
    params = Enum.drop(params, 1)
    params = Enum.join(params, ", ")

    messages = %{
      "blank" => "#{params} can't be blank",
      "invalid" => "#{params} has invalid id",
      "exist" => "#{params} doesn't exist",
      "utc_datetime" => "#{params} must be utc datetime"
    }

    code = %{"blank" => 422, "invalid" => 400, "exist" => 404, "utc_datetime" => 422}

    conn
    |> put_status(code[type])
    |> put_view(QuizGenerator.ErrorView)
    |> render("error.json",
      code: code[type],
      message: messages[type]
    )
  end

  @spec custom_return(Plug.Conn.t(), list(), String.t()) :: Plug.Conn.t()
  def custom_return(conn, params, message) do
    type = hd(params)
    params = Enum.drop(params, 1)
    params = Enum.join(params, ", ")

    messages =
      case params == "" do
        true ->
          %{type => "#{message}"}

        _ ->
          %{type => "#{params} #{message}"}
      end

    code = %{"422" => 422, "400" => 400, "404" => 404}

    conn
    |> put_status(code[type])
    |> put_view(QuizGenerator.ErrorView)
    |> render("error.json",
      code: code[type],
      message: messages[type]
    )
  end

  @spec is_blank(map(), list()) :: true | {false, list()}
  def is_blank(params, list) do
    blank_params =
      Enum.filter(list, fn x ->
        if is_nil(params[x]) do
          x
        end
      end)

    case blank_params do
      [] ->
        true

      _ ->
        type_params = ["blank"] ++ blank_params
        {false, type_params}
    end
  end

  @spec is_invalid(map(), list()) :: true | {false, list()}
  def is_invalid(params, list) do
    invalid_ids =
      Enum.filter(list, fn x ->
        if Ecto.UUID.cast(params[x]) == :error do
          x
        end
      end)

    case invalid_ids do
      [] ->
        true

      _ ->
        type_params = ["invalid"] ++ invalid_ids
        {false, type_params}
    end
  end

  @spec is_exist(map(), list(), list()) :: true | {false, list()}
  def is_exist(params, list, struct_list) do
    non_existing_params =
      Enum.filter(list, fn x ->
        index = Enum.find_index(list, fn value -> value == x end)

        if struct_list |> Enum.at(index) |> Repo.get_by(id: params[x]) == nil do
          x
        end
      end)

    case non_existing_params do
      [] ->
        true

      _ ->
        type_params = ["exist"] ++ non_existing_params
        {false, type_params}
    end
  end

  @spec is_valid_all(map(), list(), list() | nil) :: true | {false, list()}
  def is_valid_all(params, list, struct_list \\ nil) do
    case is_blank(params, list) do
      true ->
        is_invalid = is_invalid(params, list)

        if is_invalid == true && struct_list != nil do
          is_exist(params, list, struct_list)
        else
          is_invalid
        end

      result ->
        result
    end
  end

  @spec check_blank(map(), list()) :: boolean()
  def check_blank(params, list) do
    case is_blank(params, list) do
      true -> true
      _ -> false
    end
  end

  @spec check_invalid(map(), list()) :: boolean()
  def check_invalid(params, list) do
    case is_invalid(params, list) do
      true -> true
      _ -> false
    end
  end

  @spec check_exist(map(), list(), list()) :: boolean()
  def check_exist(params, list, struct_list) do
    case is_exist(params, list, struct_list) do
      true -> true
      _ -> false
    end
  end

  @spec check_valid_all(map(), list(), nil | list()) :: boolean()
  def check_valid_all(params, list, struct_list \\ nil) do
    case is_valid_all(params, list, struct_list) do
      true -> true
      _ -> false
    end
  end

  @spec is_valid_utc_date_time(map(), list()) :: true | {false, list()}
  def is_valid_utc_date_time(params, list) do
    case is_blank(params, list) do
      true ->
        invalid_dates =
          Enum.filter(list, fn x ->
            if DateTime.from_iso8601(params[x]) == {:error, :invalid_format} do
              x
            end
          end)

        case invalid_dates do
          [] ->
            true

          _ ->
            type_params = ["utc_datetime"] ++ invalid_dates
            {false, type_params}
        end

      {false, err} ->
        err
    end
  end
end
