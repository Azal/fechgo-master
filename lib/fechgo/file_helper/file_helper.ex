defmodule Fechgo.FileHelper do
  def path(file) do
    Path.join(Application.get_env(:fechgo, :uploads_path), file)
  end
end
