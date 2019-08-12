#!/usr/bin/env ruby
require File.expand_path(File.join(__FILE__, %w(.. .. config environment)))
require 'libs/web_server'
require 'libs/router'

EM.run do
  server = WebServer.new
  router = Router.new(redis: App.em_hiredis)
  server.settings.router = router

  dispatch = Rack::Builder.app do
    map '/' do
      run server
    end
  end

  Rack::Server.start({
    app: dispatch,
    server: ENV['SERVER_NAME'],
    Host: ENV['SERVER_HOST'],
    Port: ENV['SERVER_PORT'],
    signals: false
  })
end
