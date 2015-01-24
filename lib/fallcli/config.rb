require 'singleton'
require 'fileutils'

module FallCli
  # This is the configuration object. It reads in configuration
  # from a .fallcli file located in the user's home directory

  class Configuration
    include Singleton
    attr_reader :data
    attr_reader :path

    FILE_NAME = '.fallcli/config'

    def initialize
      @path = ENV["FALLCLI_CONFIG_PATH"] || File.join(File.expand_path("~"), FILE_NAME)
      @data = self.load_config_file
    end

    # If we can't load the config file, self.data is nil, which we can
    # check for in CheckConfiguration
    def load_config_file
      require 'yaml'
      YAML.load_file(@path)
    rescue Errno::ENOENT
      return
    end

    def app_key
      @data['authentication']['app_key']
    end

    def secret_key
      @data['authentication']['secret_key']
    end

    def app_token
      @data['client']['app_token']
    end

    def app_secret
      @data['client']['app_secret']
    end

    # Re-runs initialize
    def reset!
      self.send(:initialize)
    end

    # Re-loads the config
    def reload!
      @data = self.load_config_file
    end

    # Writes a config file
    def create_config_file(app_key, secret_key, app_token, app_secret)
      FileUtils.mkdir_p File.join(File.expand_path("~"),'.fallcli/')
      require 'yaml'
      File.open(@path, File::RDWR|File::TRUNC|File::CREAT, 0600) do |file|
        data = {
          "authentication" => { "app_key" => app_key, "secret_key" => secret_key },
          "client" => { "app_token" => app_token, "app_secret" => app_secret }
        }
        file.write data.to_yaml
      end
    end

  end
end
