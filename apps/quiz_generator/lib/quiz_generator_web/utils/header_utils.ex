defmodule QuizGenerator.HeaderUtils do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  # alias TenantApi.Constants.Headers
  alias QuizGenerator.GuardianHelper

  @spec header_value(Plug.Conn.t(), String.t(), list()) ::
          {:error, :multiple_header_values_not_accepted | :not_found} | {:ok, String.t()}
  def header_value(conn, key_name, opts \\ []) do
    case Plug.Conn.get_req_header(conn, key_name) do
      [value] ->
        {:ok, value}

      [first | _remaining] = _values ->
        if opts[:multiple_header_values_not_accepted] == true do
          {:error, :multiple_header_values_not_accepted}
        else
          {:ok, first}
        end

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  This function gets response header value belongs to provided key_name
  """
  @spec resp_header_value(Plug.Conn.t(), String.t()) :: {:error, :not_found} | {:ok, String.t()}
  def resp_header_value(conn, key_name) do
    case Plug.Conn.get_resp_header(conn, key_name) do
      [value] ->
        {:ok, value}

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  This function gets request path & replace path params with dummy value
  """
  @spec request_path(Plug.Conn.t()) :: String.t()
  def request_path(conn) do
    conn.path_params
    |> Enum.reduce(conn.path_info, fn {key, value}, acc ->
      index = Enum.find_index(acc, fn x -> x == value end)
      List.replace_at(acc, index, ":#{key}")
    end)
    |> Enum.join("/")
  end

  # # DOC: Use this ```Map.get(conn.assigns, :header_key)``` to get value from conn.assigns.header_key if it exists
  # @spec assign_optional_headers?(Plug.Conn.t(), list()) :: Plug.Conn.t()
  # def assign_optional_headers?(
  #       conn,
  #       opts \\ [:campus_id, :class_id, :section_id, :view_student_id]
  #     ) do
  #   Enum.reduce(opts, conn, fn header_key, conn ->
  #     {status, value} = header_value(conn, Headers.encode(header_key))

  #     if status == :ok and is_binary(value) do
  #       conn = %{conn | params: Map.merge(conn.params, %{Atom.to_string(header_key) => value})}
  #       Plug.Conn.assign(conn, header_key, value)
  #     else
  #       Plug.Conn.assign(conn, header_key, conn.params[Atom.to_string(header_key)])
  #     end
  #   end)
  # end

  # @doc """
  # This method is used to get value from header
  # """
  # @spec get_header_value(Plug.Conn.t(), atom()) :: String.t() | nil
  # def get_header_value(conn, header_key) do
  #   {status, value} = header_value(conn, TenantApi.Constants.Headers.encode(header_key))
  #   if status == :ok and is_binary(value), do: value
  # end

  # Will use it instead of assign_optional_headers?/2
  # def get_optional_headers(conn, opts \\ [:campus_id, :class_id, :section_id, :view_student_id]) do
  #   Enum.reduce(opts, %{}, fn header_key, options ->
  #     {status, value} = header_value(conn, Headers.encode(header_key))

  #     options =
  #       if status == :ok and is_binary(value) do
  #         Map.merge(options, %{Atom.to_string(header_key) => value})
  #       else
  #         options
  #       end

  #     options
  #   end)
  # end

  @doc """
  This function gets current role from conn
  """
  @spec get_current_role(Plug.Conn.t()) :: {:ok, String.t()}
  def get_current_role(conn) do
    {:ok, conn.assigns.role}
  end

  @doc """
  This function gets current user id from conn
  """
  @spec get_current_user_id(Plug.Conn.t()) :: {:ok, String.t()}
  def get_current_user_id(conn) do
    {:ok, GuardianHelper.current_user(conn).id}
  end

  @doc """
  This function gets value from key in the claims
  """
  @spec get_claim(Plug.Conn.t(), String.t()) :: String.t() | nil
  def get_claim(conn, claim_key) do
    TenantCampus.Guardian.Plug.current_claims(conn)[claim_key]
  end

  @doc """
  This function gets current user from conn
  """
  @spec get_current_user(Plug.Conn.t()) :: TenantData.InstituteUser.t()
  def get_current_user(conn) do
    GuardianHelper.current_user(conn)
  end
end
