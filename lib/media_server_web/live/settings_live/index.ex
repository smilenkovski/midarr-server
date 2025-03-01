defmodule MediaServerWeb.SettingsLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServer.Accounts.User
  alias MediaServer.Integrations

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    {:ok, socket |> assign(:current_user, user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Settings")
    |> assign(:users, Repo.all(User))
    |> assign(:user_name, User.name_changeset(socket.assigns.current_user))
    |> assign(:user, User.registration_changeset(%User{}, %{}))
    |> assign(:radarr, Integrations.get_first_radarr())
    |> assign(:sonarr, Integrations.get_first_sonarr())
  end
end
