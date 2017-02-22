defmodule Ghdump.Files do
  alias Ghdump.Config

  defp run(dump, {printer,stream}) do
    case dump do
      [{filename, data} | t] -> run(t,{printer,Zipflow.Stream.entry(stream,Zipflow.DataEntry.encode(printer,"#{filename}.patch",data))})
      {filename, data} ->
        Zipflow.Stream.entry(stream,Zipflow.DataEntry.encode(printer,"#{filename}.patch",data))
        Zipflow.Stream.flush(stream,printer)
      [] -> Zipflow.Stream.flush(stream,printer)
    end
  end
  def save(dump,filename) do
    file = filename <> ".zip"
    File.open(Config.filedir <> file, [:raw, :binary, :write], fn fh ->
      printer = & IO.binwrite(fh, &1)
      run(dump, {printer,Zipflow.Stream.init})
    end)
    {Config.filedir, file}
  end
end
