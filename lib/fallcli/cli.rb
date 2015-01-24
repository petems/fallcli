require 'thor'

module FallCli
  autoload :Middleware, "fallcli/middleware"

  class CLI < Thor
    include Thor::Actions
    ENV['THOR_COLUMNS'] = '120'

    !check_unknown_options

    map "--version"      => :version,
        "-v"             => :version

    desc "help [COMMAND]", "Describe commands or a specific command"
    def help(meth=nil)
      super
      if !meth
        say "To learn more or to contribute, please see github.com/petems/fallcli"
      end
    end

    desc "authorize", "Authorize a Dropbox account with fallcli"
    long_desc "This takes you through a workflow for adding configuration
    details to fallcli."
    def authorize
      Middleware.sequence_authorize.call({})
    end

    desc "browser", "Run the browser"
    long_desc "This is the file browser that renders a CLI to browse your Dropbox
    files, and you can navigate using the arrow keys"
    def browser
      Middleware.sequence_browser.call({})
    end

    desc "upload-browser", "Run the upload-browser"
    long_desc "This is the file browser that renders your local file system files
    files, and you can upload with the CLI"
    def uploader_browser
      Middleware.sequence_upload_browser.call({})
    end

    desc "verify", "Check your given credentials are valid"
    long_desc "This checks that the credentials in ~/.fallcli are correct"
    def verify
      Middleware.sequence_verify.call({})
    end

    desc "get-keys", "Get your app and secret keys"
    def get_keys
      say "Please open this URL from your Browser, and login: https://www.dropbox.com/developers/apps"
      say "Click \"Create app\" button, and choose the following options:"
      say "Type: Dropbox API app"
      say "Data: Files and Datastores"
      say "Permission type: Full Dropbox"
      say "File Types: All file types"
      say "App name: FallCli#{Time.now.to_i}"
      say "Cick on the \"Create\" button, and note down the 'app key' and 'app secret'"
    end

    desc "version", "Show version"
    def version
      say "FallCli #{FallCli::VERSION}"
    end

  end
end

