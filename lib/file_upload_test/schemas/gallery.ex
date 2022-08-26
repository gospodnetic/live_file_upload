defmodule FileUploadTest.Gallery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "galleries" do
    field :my_images, :string
  end

  def changeset(gallery, attrs \\ %{}) do
    gallery
    |> cast(attrs, [:my_images])
  end
end
