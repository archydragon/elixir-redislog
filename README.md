# elixir-redislog

Very simple backend for standard Elixir logger to push JSON wrapped messages to
Redis pubsub queue.

## Installation

Add dependency to your `mix.exs` file:

```elixir
def deps do
  [{:redislog, ">= 0.0.0"}]
end
```

Then, run `mix deps.get` in your shell to fetch the new dependency.

## Configuration

Update your configuration under `config` folder in the following manner:

```elixir
config :logger,
  backends: [{Redislog, :info}] # send all messages but debug

config :redislog,
  host: "127.0.0.1", # optional, fallback to "127.0.0.1"
  port: 6379,        # optional, fallback to 6379
  password: "",      # optional
  queue: ""          # mandatory, name of pubsub variable in Redis
```

## Usage

Since it is standard logger wrapper, all log messages created using
`Logger.info` and similar commands will be sent automatically.

Encoded message example:
```json
{
  "timestamp": "2018-07-17T14:54:25.607Z",
  "meta": {
    "module": null,
    "line": 92,
    "function": null,
    "file": "iex",
    "additional_information": "something here"
  },
  "message": "test log message",
  "level": "error",
  "hostname":"localhost"
}
```

## TODO

* Tests
* Support Redis clusters
* More flexible configuration

## License

MIT
