defmodule FileUploadTestWeb.IndexLive do
  use FileUploadTestWeb, :live_view

  alias FileUploadTest.Gallery

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(
        changeset: Gallery.changeset(%Gallery{}),
        uploaded_files: []
      )
      |> allow_upload(
        :my_images,
        accept: ~w(.jpg .jpeg .png),
        max_entries: 2
      )
    }
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    IO.inspect(socket)
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    IO.inspect(ref, label: "Cancelling upload")
    # {:noreply, socket}
    {:noreply, cancel_upload(socket, :my_images, ref)}
  end

  def handle_event("save", params, socket) do
    uploaded_files =
    consume_uploaded_entries(socket, :my_images, fn %{path: path}, _entry ->
      dest = Path.join("priv/static/uploads", Path.basename(path))
      File.cp!(path, dest)
      {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}
    end)
    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  def error_to_string(:too_large), do: "Image selected is too large"
  def error_to_string(:not_accepted), do: "Unacceptable file type"
  def error_to_string(:too_many_files), do: "You have selected too many files"

  @impl
  def render(assigns) do
    ~H"""
      <div class="container p-0">
        <.form let={f} for={@changeset} phx-change="validate" phx-submit="save">
          <div class="row">
            <div class="col-4">
              <%= live_file_input @uploads.my_images, class: "form-control"%>
            </div>

            <div class="col-8">
              <%= if length(@uploads.my_images.entries) > 0 && length(upload_errors(@uploads.my_images)) == 0 do %>
                <button class="btn btn-primary" type="submit">Upload</button>
                <% else %>
                <button class="btn btn-primary disabled" type="submit">Upload</button>
              <% end %>
            </div>
          </div>

          <div class="row m-0">
            <div class="col-12 position-relative mt-2 mb-2 upload_field border border-2 border-success rounded" phx-drop-target={@uploads.my_images.ref}>
              Choose a file or drag it here.
              <%= Bootstrap.Icons.cloud_arrow_up(width: 100, height: 100, class: "position-absolute top-50 start-50 translate-middle") %>
            </div>
          </div>
          <label class="mb-2">Allowed file types: .jpg, .jpeg or .png</label>

          <div class="row m-0 mb-2">
            <%= for error <- upload_errors(@uploads.my_images) do %>
              <div class="alert alert-danger">
                <%= error_to_string(error) %>
              </div>
            <% end %>
          </div>

          <div class="row gy-2 m-0">
            <%= for entry <- @uploads.my_images.entries do %>
              <div class="col-4 ps-0">
                <%= live_img_preview entry, width: 150 %>
              </div>

              <div class="col-4">
                <progress max="100" value={entry.progress} />
              </div>

              <div class="col-1">
                <button class="btn btn-primary" type="button" phx-click="cancel-upload" phx-value-ref={entry.ref}>&times;</button>
              </div>

              <div class="col-3">
                <%= for error <- upload_errors(@uploads.my_images, entry) do %>
                  <div class="alert alert-danger">
                    <%= error_to_string(error) %>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        </.form>
      </div>
    """
  end
end
