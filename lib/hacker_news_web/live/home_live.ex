defmodule HNWeb.HomeLive do
  use HNWeb, :live_view

  def mount(_params, _session, socket) do
    stories =
      Finch.build(:get, "https://node-hnapi.herokuapp.com/news")
      |> Finch.request!(HN.Finch)
      |> Map.get(:body)
      |> Jason.decode!()

    {:ok, stream(socket, :stories, stories, dom_id: & &1["id"])}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="my-2" :for={{_, story} <- @streams.stories}>
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
