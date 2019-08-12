require "sinatra/base"
require 'sinatra-websocket'
require "sinatra/reloader" if App.development?
require 'slim'
require 'uglifier'
require 'sprockets'
require 'eventmachine'
require 'em-hiredis'


class WebServer < Sinatra::Base
  set :views, App.views_path
  set :environment, App.env
  set :root, App.root
  set :router, nil
  set :threaded, false
  set :traps, false

  register Sinatra::Reloader if App.development?

  not_found { halt 404 }
  error { halt 500 }

  get '/' do
    if request.websocket?
      settings.router.process_request(request)
    else
      slim :index
    end
  end

  get '/status' do
    halt 200, 'OK'
  end

  set :sprockets, Sprockets::Environment.new(App.root)
  set :assets_prefix, '/assets'
  set :digest_assets, false
  sprockets.append_path "assets/stylesheets"
  sprockets.append_path "assets/javascripts"
  sprockets.js_compressor = Uglifier.new(harmony: true) #:uglify
  sprockets.css_compressor = :scss

  get "/assets/*" do
    env["PATH_INFO"].sub!("/assets", "")
    settings.sprockets.call(env)
  end
end
