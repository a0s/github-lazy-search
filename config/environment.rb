$:.unshift File.expand_path(File.join(__FILE__, %w(.. ..)))

ENV['APP_ENV'] ||= 'development'
ENV['WORKERS_COUNT'] ||= '3'
ENV['WORKERS_INPUT_QUEUE'] ||= 'tasks'
ENV['WORKERS_OUTPUT_QUEUE'] ||= 'results'
ENV['SERVER_NAME'] ||= 'thin'
ENV['SERVER_HOST'] ||= 'localhost'
ENV['SERVER_PORT'] ||= '3000'
ENV['GITHUB_TOKEN'] || fail('GITHUB_TOKEN env is not defined')
# ENV['REDIS_URL'] ||= 'redis://localhost:6379/1'

require 'libs/application'
