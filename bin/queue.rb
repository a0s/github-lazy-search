#!/usr/bin/env ruby
require File.expand_path(File.join(__FILE__, %w(.. .. config environment)))
require 'redis'
require 'redis-queue'
require 'libs/worker'
require 'libs/job'

Thread.abort_on_exception = true

threads = []

App.workers_count.times do |i|
  threads << Thread.new do
    redis = App.redis(new: true)
    Worker.new(redis_queue: App.redis_queue(redis: redis)).run!
  end
end

puts "#{App.workers_count} workers started"

threads.each(&:join)
