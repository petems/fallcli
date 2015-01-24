require "dropbox-api"
require "cgi"

module FallCli
  module Middleware
    # Ask for user credentials from the command line, then write them out.
    class AskForCredentials < Base
      def call(env)

        say "If you dont know your app and secret key, try `fallcli get-keys`"

        app_key = ask "Enter your App key:"
        secret_key = ask "Enter your Secret key:"

        Dropbox::API::Config.app_key    = app_key
        Dropbox::API::Config.app_secret = secret_key

        consumer = Dropbox::API::OAuth.consumer(:authorize)
        request_token = consumer.get_request_token
        say "Go to this url and click 'Authorize' to get the token:"
        say request_token.authorize_url, :green
        query  = request_token.authorize_url.split('?').last
        params = CGI.parse(query)
        token  = params['oauth_token'].first
        yes? "Once you authorize the app on Dropbox, type yes... "
        access_token  = request_token.get_access_token(:oauth_verifier => token)

        # Write the config file.
        env['config'].create_config_file(app_key, secret_key, access_token.token, access_token.secret)
        env['config'].reload!

        say "Credentials saved to ~/.fallcli"

        @app.call(env)
      end
    end
  end
end

