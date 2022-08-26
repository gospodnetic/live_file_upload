# FileUploadTest

An example single upload page made by following the [Tracey Onim Medium post](https://medium.com/@traceyonim22/how-to-enable-file-uploads-with-phoenix-liveview-3d224de9def5), adding minor upgrades to have it work nicely.

## List of changes
* Use `changeset` defined in the `Gallery` schema
* Make cancel button of `type="button"`, otherwise the form buttons are made `type="submit"` by default
* Ensure `uploads` directory is available in `priv/static`
* Added a general error message if there are too many files selected
* Enable upload button only if there is something to upload and no errors are present

# Running the example
To start your Phoenix server:

  * Install npm dependencies with
  ```
  cd assets
  npm install
  ```
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:3000`](http://localhost:3000) from your browser.
