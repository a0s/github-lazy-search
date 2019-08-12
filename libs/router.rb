require 'redis-queue'
require 'json'
require 'eventmachine'

class Router
  def initialize(redis:)
    @redis = redis
    @tasks = {} # UUID => WebSocket
    process_response
  end

  def process_request(request)
    request.websocket do |ws|
      ws.onmessage do |msg|
        data = JSON.parse(msg)
        @tasks[data['query_uuid']] = ws
        message = JSON.dump({
          klass: 'Job',
          args: {
            query_uuid: data['query_uuid'],
            query: data['query']
          }
        })
        @redis.lpush(ENV['WORKERS_INPUT_QUEUE'], message)
      end
      ws.onclose do
        @tasks.reject! { |_, _ws| _ws == ws }
      end
    end
  end

  def process_response
    pubsub = @redis.pubsub
    pubsub.subscribe(ENV['WORKERS_OUTPUT_QUEUE'])
    pubsub.on(:message) do |_, message|
      data = JSON.parse(message)
      if data['query_uuid'] && (web_socket = @tasks[data['query_uuid']])
        web_socket.send(message)
        @tasks.delete(data['query_uuid'])
      end
    end
  end
end
