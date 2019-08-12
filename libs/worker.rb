require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require 'json'

class Worker
  def initialize(redis_queue:)
    @redis_queue = redis_queue
  end

  def run!
    while (message_str = @redis_queue.pop)
      begin
        message = JSON.parse(message_str)
        message.symbolize_keys!
        klass = message[:klass].constantize
        args = (message[:args] || []).symbolize_keys!
        klass.new.perform(**args)
      rescue StandardError => ex
        puts "Smth wrong with message `#{message_str}, skipped': #{ex}\n#{ex.backtrace.join("\n")}."
      ensure
        @redis_queue.commit
      end
    end
  end
end
