defmodule PandaProxy.Web do
  use Plug.Router

  import Plug.Conn

  plug CORSPlug, origin: "*"
  plug :match
  plug :dispatch

  get "/hello_world" do
    send_resp(conn, 200, "Hello, World!")
  end

  get "/upcoming_matches" do
    matches = fetch_upcoming_matches()
    send_resp(conn, 200, matches)
    # case fetch_upcoming_matches() do
    # json_string when is_binary(json_string) ->
    #   send_resp(conn, 200, json_string)

    # _ ->
    #   # Handle unexpected cases (if any)
    #   send_resp(conn, 500, Jason.encode!(%{error: "Internal server error"}))
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  # def render_matches do
  #   case upcoming_matches() do
  #     {:ok, list} ->
  #       {:ok, list}

  #     {:error, reason} ->
  #       Jason.encode!(%{error: reason})
  #   end
  # end

  defp fetch_upcoming_matches do
    case PandaProxy.render_matches() do
      {:ok, list} ->
        list

      {:error, reason} ->
        Jason.encode!(%{error: reason})
    end
  end
end
