defmodule Campus.StringUtils do
  @moduledoc """
  # TODO: Write proper moduledoc
  """
  @spec trim_non_empty_field(String.t(), String.t()) :: String.t()
  def trim_non_empty_field(text, trimming_character) when not is_nil(text) do
    String.trim(text, trimming_character)
  end

  def trim_non_empty_field(text, _), do: text

  @spec replace_non_empty_key(String.t(), String.t(), String.t()) :: String.t()
  def replace_non_empty_key(text, pattern, replacement) when not is_nil(text) do
    String.replace(text, pattern, replacement)
  end

  def replace_non_empty_key(text, _, _), do: text

  @spec get_locked_key(String.t() | atom()) :: String.t() | atom()
  def get_locked_key(key) do
    if is_atom(key) do
      String.to_atom("is_locked_#{Atom.to_string(key)}")
    else
      "is_locked_#{key}"
    end
  end

  @spec downcase_with_remove_spacing(String.t()) :: String.t()
  def downcase_with_remove_spacing(text) do
    text
    |> String.downcase()
    |> String.replace(~r/[\s]/, "")
  end

  @spec generate_tenant_prefix(String.t()) :: String.t()
  def generate_tenant_prefix(sub_domain) do
    sub_domain =
      sub_domain
      |> String.downcase()
      |> String.replace("-", "")

    tenant_prefix =
      ~r/^[a-zA-Z0-9_]+$/
      |> Regex.scan(sub_domain)
      |> List.flatten()
      |> Enum.join("")
      |> String.slice(0..5)

    rand_str = generate_random_string()
    "#{rand_str}_#{tenant_prefix}"
  end

  @doc """
  Generate a sub_domain if not provided by user at time of registration

  This function attempts to use abbreviation of the institute name as first
  choice of sub_domain, in case institute name has more then 2 words in it.
  Otherwise a random string is appended into the abbreviation
  """
  @spec generate_sub_domain(String.t()) :: String.t()
  def generate_sub_domain(institute_name) do
    splitted_name = String.split(institute_name)

    abbreviated_name =
      Enum.reduce(splitted_name, "", fn word, name ->
        letter =
          word
          |> String.at(0)
          |> String.downcase()

        name <> letter
      end)

    case length(splitted_name) do
      lenght when lenght > 2 ->
        # when an institute has more then 2 words, we return
        # the abbreviation of the institute name
        # e.g Sadiq Public School, having 3 words in name, is returned
        # as `sps`
        abbreviated_name

      _ ->
        # otherwise, we append a few random characters, to have a
        # desireable sub_domain
        abbreviated_name <> generate_random_string()
    end
  end

  defp generate_random_string do
    # three characters long random string
    for _ <- 0..3, into: "", do: <<Enum.random(?a..?z)>>
  end
end
