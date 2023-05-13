defmodule HNWeb.ItemLive do
  use HNWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    item =
      Finch.build(:get, "https://node-hnapi.herokuapp.com/item/#{id}")
      |> Finch.request!(HN.Finch)
      |> Map.get(:body)
      |> Jason.decode!()

    {:ok, assign(socket, :item, item)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-3">
      <div>
        <div class="flex items-center">
          <a href={@item["url"]}>
            <span class="font-medium"><%= @item["title"] %></span>
            <span class="text-sm text-gray-700 hover:underline">
              (<%= @item["domain"] %>)
            </span>
          </a>
        </div>
        <div class="flex space-x-1 text-xs">
          <span class="text-sm text-gray-700"><%= @item["points"] %> points</span>
          <span class="text-sm text-gray-700"><%= @item["user"] %></span>
          <span class="text-sm text-gray-700"><%= @item["time_ago"] %></span>
          <.link navigate={~p"/items/#{@item["id"]}"} class="text-sm text-gray-700 hover:underline">
            <%= @item["comments_count"] %> comments
          </.link>
        </div>
      </div>
      <div :for={comment <- @item["comments"]} class="mx-8 my-4">
        <.live_component
          module={HNWeb.Components.Comment}
          id={comment["id"]}
          user={comment["user"]}
          time_ago={comment["time_ago"]}
          open={true}
          content={comment["content"]}
          comments={comment["comments"]}
        />
      </div>
    </div>
    """
  end
end
