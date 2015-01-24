module FallCli
  module Middleware
    # Check if the client has set-up configuration yet.
    class InteractiveCLI < Base
      def call(env)
        config = env["config"]

        say "RUN THE CLI"

        @app.call(env)
      end
    end
  end
end