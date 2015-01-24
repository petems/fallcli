require 'spec_helper'

shared_context "spec" do
  # Default configuration and
  let(:config)           { FallCli::Configuration.instance }
  let(:app_key)          { "foo" }
  let(:secret_key)       { "bar" }
  let(:app_token)        { "baz" }
  let(:app_secret)       { "qux" }
  let(:app)              { lambda { |env| } }
  let(:env)              { {} }

  before(:each) do
    $stdout.sync = true
    $stderr.sync = true

    @cli = FallCli::CLI.new

    # Set a temprary project path and create fake config.
    config.create_config_file(app_key, secret_key, app_token, app_secret)
    config.reload!

    # Keep track of the old stderr / out
    @orig_stderr = $stderr
    @orig_stdout = $stdout

    # Make them strings so we can manipulate and compare.
    $stderr = StringIO.new
    $stdout = StringIO.new

  end

  after(:each) do
    # Reassign the stderr / out so rspec can have it back.
    $stderr = @orig_stderr
    $stdout = @orig_stdout
  end

  after(:each) do
    # Delete the temporary configuration file if it exists.
    File.delete(project_path + "/tmp/fallcli") if File.exist?(project_path + "/tmp/fallcli")
  end

end
