defmodule Ghdump.Flow do
  alias Ghdump.{ Config, Files, Ftp }

  def dump do
    today = DateTime.utc_now
    beginning_of_the_month = %{today | day: 1}

    client = Tentacat.Client.new(%{access_token: Config.access_token})
    %{"login" => user_name} = Tentacat.Users.me(client)

    Tentacat.Repositories.list_orgs(Config.org_name, client)
    |> Flow.from_enumerable(max_demand: 20)
    |> Flow.partition(max_demand: 100, stages: 50)
    |> Flow.map(fn(repo) -> %{"name" => name} = repo; name end)
    |> Flow.flat_map(fn(repo_name) ->
      Tentacat.Commits.filter(Config.org_name, repo_name, %{author: user_name, since: beginning_of_the_month}, client)
      |> Enum.map(fn(commit) -> %{"sha" => sha} = commit; sha end)
      |> zip
      |> Flow.from_enumerable
      |> Flow.partition(max_demand: 100, stages: 50)
      |> Flow.map(fn({prev,next}) -> Tentacat.Commits.compare(prev, next, Config.org_name, repo_name, client) end)
      |> Flow.reduce(fn -> [] end, fn item, list -> [item|list] end)
    end)
    |> Flow.flat_map(fn diff -> %{"files" => files} = diff; files end)
    |> Flow.filter_map(
         fn(file) -> match?(%{"patch" => _p}, file) end,
         fn(file) ->(%{"patch" => p,"filename" => f} = file; {f,p})
    end)
    |> Enum.to_list
    |> Files.save(beginning_of_the_month |> DateTime.to_date |> to_string)
    |> Ftp.upload
  end

  defp zip(shas) do
    case shas do
      [_h|t] -> Stream.zip(t,shas)
      [h] -> Stream.zip("",h)
      _ -> []
    end
  end
end
