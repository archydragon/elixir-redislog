defmodule Redislog do
  @behaviour :gen_event

  defmodule Message do
    @derive [Poison.Encoder]
    defstruct [:hostname, :level, :timestamp, :message, :meta]
  end

  def init({_name, level}) do
    host = Application.get_env(:redislog, :host)
    port = Application.get_env(:redislog, :port)
    pwd = Application.get_env(:redislog, :password)
    queue = Application.get_env(:redislog, :queue)

    if queue == "" do
      raise "Redis pubsub queue not configured"
    end

    {:ok, redis_pid} = case pwd do
      "" -> Redix.start_link(host: host, port: port)
      _  -> Redix.start_link(host: host, port: port, password: pwd)
    end
    {:ok, hostname} = :inet.gethostname
    hostname_string = to_string(hostname)

    state = %{
      redis_pid: redis_pid,
      queue: queue,
      hostname: hostname_string,
      min_level: level
    }

    {:ok, state}
  end

  def handle_event({level, _gl, {Logger, msg, ts, md}}, %{min_level: min_level,
                                                          redis_pid: redis_pid,
                                                          queue: queue,
                                                          hostname: hostname} = state) do
    # only log if no minimal log level specified or it isn't lower than message level
    if (is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt) do
      payload = Poison.encode! %Message{
        hostname: hostname,
        level: level,
        timestamp: log_ts_to_iso8601(ts),
        message: msg,
        meta: md |> Enum.into(%{}) |> Map.delete(:pid)
      }
      Redix.command(redis_pid, ["PUBLISH", queue, payload])
    end
    {:ok, state}
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  defp log_ts_to_iso8601({date, {h, m, s, ms} = time}) do
    {:ok, n} = NaiveDateTime.from_erl({date, {h, m, s}}, {ms * 1000, 3})
    {:ok, dt} = DateTime.from_naive(n, "Etc/UTC")
    DateTime.to_iso8601(dt)
  end

end
