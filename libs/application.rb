require 'redis'
require 'redis-queue'
require 'em-hiredis'

module Application
  module_function

  def name
    'Github Lazy Searcher'
  end

  def root
    File.expand_path(File.join(__FILE__, %w(.. ..)))
  end

  def views_path
    File.join(root, %w(views))
  end

  def env
    ENV['APP_ENV'].to_sym
  end

  def development?
    :development === env
  end

  def production?
    :production === env
  end

  # Same redis-client in different threads may block on synchronize(),
  # so sometimes we need uniq redis client for every thread
  def redis(new: false)
    params = {}
    params.merge!(url: ENV['REDIS_URL']) if ENV.key?('REDIS_URL')
    params.merge!(path: ENV['REDIS_PATH']) if ENV.key?('REDIS_PATH')

    if new
      Redis.new(**params)
    else
      @redis ||= Redis.new(**params)
    end
  end

  def redis_queue(redis: nil)
    redis ||= redis(new: false)
    @redis_queue ||= Redis::Queue.new(ENV['WORKERS_INPUT_QUEUE'], "#{ENV['WORKERS_INPUT_QUEUE']}_processing", redis: redis)
  end

  def em_hiredis
    @em_hiredis ||= begin
      params = []
      params << ENV['REDIS_URL'] if ENV.key?('REDIS_URL')
      params << ENV['REDIS_PATH'] if ENV.key?('REDIS_PATH')
      EM::Hiredis.connect(*params)
    end
  end

  def workers_count
    ENV['WORKERS_COUNT'].to_i
  end
end

App = Application
