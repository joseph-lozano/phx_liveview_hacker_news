defmodule HNWeb.HomeLive do
  use HNWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, stories: []), temporary_assigns: [stories: []]}
  end

  def handle_params(_params, _url, socket) do
    api_url = api_url_for(socket.assigns.live_action)

    stories =
      Finch.build(:get, api_url)
      |> Finch.request!(HN.Finch)
      |> Map.get(:body)
      |> Jason.decode!()

    {:noreply, assign(socket, :stories, stories)}
  end

  defp api_url_for(:newest), do: "https://node-hnapi.herokuapp.com/newest"
  defp api_url_for(:news), do: "https://node-hnapi.herokuapp.com/news"
  defp api_url_for(:show), do: "https://node-hnapi.herokuapp.com/show"
  defp api_url_for(:ask), do: "https://node-hnapi.herokuapp.com/ask"
  defp api_url_for(:jobs), do: "https://node-hnapi.herokuapp.com/jobs"

  def render(assigns) do
    ~H"""
    <div :for={story <- @stories} class="my-2">
      <div class="flex items-center">
        <a href={story["url"]}>
          <span class="font-medium"><%= story["title"] %></span>
          <span class="text-sm text-gray-700 hover:underline">
            (<%= story["domain"] %>)
          </span>
        </a>
      </div>
      <div class="flex space-x-1 text-xs">
        <span class="text-sm text-gray-700"><%= story["points"] %> points</span>
        <span class="text-sm text-gray-700"><%= story["user"] %></span>
        <span class="text-sm text-gray-700"><%= story["time_ago"] %></span>
        <.link navigate={~p"/items/#{story["id"]}"} class="text-sm text-gray-700 hover:underline">
          <%= story["comments_count"] %> comments
        </.link>
      </div>
    </div>
    """
  end
end
