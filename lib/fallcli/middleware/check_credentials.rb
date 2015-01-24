require 'thor'
require 'dropbox-api'
require 'cgi'

module FallCli
  module Middleware
    class CheckCredentials < Base
      def call(env)

        say "Checking credentials with Dropbox..."

        begin
            env['dropbox-client'].ls
        rescue Dropbox::API::Error => e
            say "Connection to Dropbox failed (#{e})", :red
            say "Check your ~/.fallcli/config file, and double check your credentials are correct", :yellow
            exit 1
        end

        say "Connection to dropbox successful!", :green

        @app.call(env)
      end
    end
  end
end

