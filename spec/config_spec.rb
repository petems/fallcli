require 'spec_helper'

describe FallCli::Configuration do
  include_context "spec"

  let(:tmp_path)             { project_path + "/tmp/fallcli" }

  after :each do
    # Clean up the temp file.
    File.delete(project_path + "/tmp/fallcli") if File.exist?(project_path + "/tmp/fallcli")
  end

  it "is a singleton" do
    expect(FallCli::Configuration).to be_a Class
    expect do
      FallCli::Configuration.new
    end.to raise_error(NoMethodError, /private method `new' called/)
  end

  it "has a data attribute" do
    config = FallCli::Configuration.instance
    expect(config.data).to be
  end

  describe "the file" do
    let(:app_key)       { "foo" }
    let(:secret_key)    { "bar" }
    let(:app_token)     { "baz" }
    let(:app_secret)    { "blegga" }

    let(:config)           { config = FallCli::Configuration.instance }

    before :each do
      # Create a temporary file
      config.create_config_file(app_key, secret_key, app_token, app_secret)
    end

    it "can be created" do
      expect(File.exist?(tmp_path)).to be_true
    end

    it "can be loaded" do
      data = config.load_config_file
      expect(data).to_not be_nil
    end

    describe "the file format"
      let(:data)  { YAML.load_file(tmp_path) }

      it "should have an app key" do
        auth = data["authentication"]
        expect(auth).to have_key("app_key")
      end

      it "should have a secret key" do
        auth = data["authentication"]
        expect(auth).to have_key("secret_key")
      end

      it "should have an app token" do
        client = data["client"]
        expect(client).to have_key("app_token")
      end

      it "should have an app secret" do
        client = data["client"]
        expect(client).to have_key("app_secret")
      end
  end
end
