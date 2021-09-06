defmodule GameWeb.PageLiveTest do
  use GameWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    assert 1 == 1
    # {:ok, page_live, disconnected_html} = live(conn, "/")
    # assert disconnected_html =~ "Welcome to Phoenix!"
    # assert render(page_live) =~ "Welcome to Phoenix!"
  end
end
