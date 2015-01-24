require "middleware"

module FallCli
  module Middleware
    autoload :Base, "fallcli/middleware/base"

    autoload :AskForCredentials, "fallcli/middleware/ask_for_credentials"
    autoload :InteractiveCLI, "fallcli/middleware/interactive_cli"
    autoload :CheckConfiguration, "fallcli/middleware/check_configuration"
    autoload :CheckCredentials, "fallcli/middleware/check_credentials"
    autoload :InjectClient, "fallcli/middleware/inject_client"
    autoload :InjectConfiguration, "fallcli/middleware/inject_configuration"

    def self.sequence_authorize
      ::Middleware::Builder.new do
        use InjectConfiguration
        use AskForCredentials
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use CheckCredentials
      end
    end

    def self.sequence_interactive_cli
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use InteractiveCLI
      end
    end

    def self.sequence_verify
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use CheckCredentials
      end
    end

  end
end
