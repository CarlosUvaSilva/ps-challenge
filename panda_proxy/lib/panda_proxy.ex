defmodule PandaProxy do
  @moduledoc """
  A client for interacting with a Pandascore API.
  """

  alias HTTPoison.Response
  alias HTTPoison.Error

  @api_url "https://api.pandascore.co/lol/matches/upcoming"
  @auth_token System.get_env("PANDASCORE_AUTH_TOKEN")
  # @auth_token "x9y7IvOs9tO223w8NiMbkXVsPk2V0pD7WqS84BEY48kpbXD5-Qw"

  @doc """
  Renders the fetched list.
  """

  def render_matches(team_filter \\ nil) do
    # case upcoming_matches() do
    #   {:ok, list} ->
    #     {:ok, Jason.encode!(list)}

    #   {:error, reason} ->
    #     Jason.encode!(%{error: reason})
    # end
    try do
      matches = upcoming_matches(team_filter)
      {:ok, Jason.encode!(matches)}
    rescue
      _ -> {:error, "Error"}
    end
  end


  @doc """
  Fetches a list from the API.
  """
  def upcoming_matches(team_filter \\ nil) do
    params = %{
      "sort" => "begin_at",
      "per_page" => "5",
      "filter[opponent_id]" => team_filter,
    }

    full_url = build_url(@api_url, params)
    headers = [{"Authorization", "Bearer #{@auth_token}"}]

    case HTTPoison.get(full_url, headers) do
      {:ok, %Response{status_code: 200, body: body}} ->
        case process_games(body) do
          {:ok, data} -> data
          error -> error
        end

      {:ok, %Response{status_code: status_code}} ->
        {:error, "Request failed with status code #{status_code}"}

      {:error, %Error{reason: reason}} ->
        {:error, "Request error: #{reason}"}
    end
  end

  defp build_url(base_url, params) when is_map(params) do
    filtered_params = Enum.filter(params, fn {_, v} -> !is_nil(v) end)
    query_string = URI.encode_query(filtered_params)
    if query_string == "", do: base_url, else: "#{base_url}?#{query_string}"
  end

  @doc """
  Processes the API response to extract match details.
  """
  defp process_games(response) do
    case Jason.decode(response) do
    {:ok, data} ->
      matches = Enum.filter_map(data, &valid_game?(&1), &extract_match_details/1)
      {:ok, matches}

    {:error, _} ->
      {:error, "Invalid JSON format"}
  end
  end

  defp valid_game?(%{"scheduled_at" => _scheduled_at, "id" => _id, "name" => _name}), do: true
  defp valid_game?(_), do: false

  defp extract_match_details(%{"scheduled_at" => scheduled_at, "id" => id, "name" => name}) do
    %{"scheduled_at" => scheduled_at, "id" => id, "name" => name}
  end
end
