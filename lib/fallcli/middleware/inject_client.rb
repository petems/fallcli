require 'thor'
require "dropbox-api"

module FallCli
  module Middleware
    class InjectClient < Base
        def call(env)

          Dropbox::API::Config.app_key    = env['config'].app_key
          Dropbox::API::Config.app_secret = env['config'].secret_key
          Dropbox::API::Config.mode       = 'dropbox'

          begin
            client = Dropbox::API::Client.new(:token  => env['config'].app_token, :secret =>  env['config'].app_secret)
          rescue Dropbox::API::Error => e
            say "Connection to Dropbox failed (#{e})", :red
            exit 1
          end

          env['dropbox-client'] = client

          @app.call(env)
        end
    end
  end
end

