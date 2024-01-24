defmodule Panda do
  @moduledoc """
  A client for interacting with a Pandascore API.
  """

  alias HTTPoison.Response
  alias HTTPoison.Error

  @api_url "https://api.pandascore.co/lol/matches/upcoming"
  @auth_token System.get_env("PANDASCORE_AUTH_TOKEN")

  @doc """
  Renders the fetched list.
  """
  def render_matches(team_filter \\ nil) do
    try do
      matches = upcoming_matches(team_filter)
      {:ok, Jason.encode!(matches)}
    rescue
      error in Jason.EncodeError ->
        {:error, "Failed to encode matches: #{error.message}"}
      error in RuntimeError ->
        {:error, "Runtime error: #{error.message}"}
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
        {:error, "HTTP request failed: #{reason}"}
    end
  end

  defp build_url(base_url, params) when is_map(params) do
    filtered_params = Enum.filter(params, fn {_, v} -> !is_nil(v) end)
    query_string = URI.encode_query(filtered_params)
    if query_string == "", do: base_url, else: "#{base_url}?#{query_string}"
  end

  defp process_games(response) do
    case Jason.decode(response) do
      {:ok, data} ->
        matches = Enum.flat_map(data, fn game ->
          if valid_game?(game) do
            [extract_match_details(game)]
          else
            []
          end
        end)
        {:ok, matches}

      {:error, reason} ->
        {:error, "Invalid JSON format: #{reason}"}
    end
  end

  defp valid_game?(%{"scheduled_at" => _scheduled_at, "id" => _id, "name" => _name}), do: true
  defp valid_game?(_), do: false

  defp extract_match_details(%{"scheduled_at" => scheduled_at, "id" => id, "name" => name}) do
    %{"scheduled_at" => scheduled_at, "id" => id, "name" => name}
  end
end
