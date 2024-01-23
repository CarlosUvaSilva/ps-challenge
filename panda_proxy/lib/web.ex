defmodule Panda.Web do
  use Plug.Router

  import Plug.Conn

  plug CORSPlug, origin: "*"
  plug :match
  plug :dispatch

  get "/hello_world" do
    send_resp(conn, 200, "Hello, World!")
  end

  get "/upcoming_matches" do
    # Fetch and parse the query parameters
    conn = fetch_query_params(conn)
    query_params = conn.query_params
    team_param = get_in(query_params, ["team"])

    matches = fetch_upcoming_matches(team_param)
    send_resp(conn, 200, matches)
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp fetch_upcoming_matches(team_param) do
    case Panda.render_matches(team_param) do
      {:ok, list} ->
        list

      {:error, reason} ->
        Jason.encode!(%{error: reason})
    end
  end
end
