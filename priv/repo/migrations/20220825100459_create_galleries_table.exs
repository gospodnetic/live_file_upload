defmodule FileUploadTest.Repo.Migrations.CreateGalleriesTable do
  use Ecto.Migration

  def change do
    create table(:galleries) do
      add :my_images, :string
    end
  end
end
