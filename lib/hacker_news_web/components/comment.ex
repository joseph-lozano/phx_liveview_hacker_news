defmodule HNWeb.Components.Comment do
  use HNWeb, :live_component

  attr :open, :boolean, default: false
  attr :user, :string, default: ""
  attr :time_ago, :string, default: ""
  attr :content, :string, default: ""
  attr :comments, :list, default: []

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex space-x-1 text-xs">
        <span class="text-sm text-gray-700"><%= @user %></span>
        <span class="text-sm text-gray-700"><%= @time_ago %></span>
        <span
          :if={@open}
          phx-target={@myself}
          phx-click="toggle-open"
          class="cursor-pointer hover:underline"
        >
          [-]
        </span>
        <span
          :if={!@open}
          phx-target={@myself}
          phx-click="toggle-open"
          class="cursor-pointer hover:underline"
        >
          [+]
        </span>
      </div>
      <p :if={@open} class="text-sm mt-4">
        <%= Phoenix.HTML.raw(@content) %>
        <div :for={comment <- @comments} class="my-4 mx-8">
          <.live_component
            module={HNWeb.Components.Comment}
            id={comment["id"]}
            user={comment["user"]}
            time_ago={comment["time_ago"]}
            open={false}
            content={comment["content"]}
            comments={comment["comments"]}
          />
        </div>
      </p>
    </div>
    """
  end

  def handle_event("toggle-open", _, socket) do
    {:noreply, assign(socket, :open, !socket.assigns.open)}
  end
end
