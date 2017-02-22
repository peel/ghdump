defmodule Ghdump.Config do
  def access_token, do: Application.get_env(:ghdump, :access_token)
  def org_name, do: Application.get_env(:ghdump, :org_name)
  def host, do: Application.get_env(:ghdump, :host)
  def username, do: Application.get_env(:ghdump, :username)
  def password, do: Application.get_env(:ghdump, :password)
  def target_dir, do: Application.get_env(:ghdump, :target_dir)
  def filedir, do: Application.get_env(:ghdump, :filedir)
end
