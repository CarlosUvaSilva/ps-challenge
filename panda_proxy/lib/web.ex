defmodule Panda.Web do
  use Plug.Router

  import Plug.Conn

  plug CORSPlug, origin: "*"
  plug :match
  plug :dispatch

  get "/hello_world" do
    send_ok_resp(conn, "Hello, World!")
  end

  get "/upcoming_matches" do
    conn = fetch_query_params(conn)
    query_params = conn.query_params
    team_param = get_in(query_params, ["team"])

    case fetch_upcoming_matches(team_param) do
      {:ok, matches} ->
        send_ok_resp(conn, matches)
      {:error, reason} ->
        send_resp(conn, 500, Jason.encode!(%{error: reason}))
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp fetch_upcoming_matches(team_param) do
    Panda.render_matches(team_param)
  end

  defp send_ok_resp(conn, body) do
    send_resp(conn, 200, body)
  end
end
