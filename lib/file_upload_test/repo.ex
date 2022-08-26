defmodule FileUploadTest.Repo do
  use Ecto.Repo,
    otp_app: :file_upload_test,
    adapter: Ecto.Adapters.Postgres
end
