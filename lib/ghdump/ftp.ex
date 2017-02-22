defmodule Ghdump.Ftp do
  alias Ghdump.Config

  def upload(args) do
    apply(__MODULE__, :upload, Tuple.to_list(args))
  end
  def upload(filedir, file) do
    :inets.start
    {:ok, pid} = :inets.start(:ftpc, host: Config.host)
    :ftp.user(pid, Config.username, Config.password)
    :ftp.pwd(pid)
    :ftp.cd(pid, Config.target_dir)
    :ftp.lcd(pid, filedir |> to_charlist)
    :ftp.send(pid, file |> to_charlist)
    IO.inspect :ftp.ls(pid, Config.target_dir)
    :inets.stop(:ftpc, pid)
  end

end
