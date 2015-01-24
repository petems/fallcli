module FallCli
  module Middleware
    # Check if the client has set-up configuration yet.
    class CheckConfiguration < Base
      def call(env)
        config = env["config"]

        if !config || !config.data || !config.app_key || !config.secret_key
          say "You must run `fallcli authorize` in order to connect to Dropbox", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end

