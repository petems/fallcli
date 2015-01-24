require 'spec_helper'

describe FallCli::CLI do
  include_context "spec"

  describe "verify" do
    it "returns confirmation text when verify passes" do
      stub_request(:get, "https://api.dropbox.com/1/metadata/dropbox/?").
      with(:headers => {'Accept'=>'*/*', 'Authorization'=> /OAuth oauth_consumer_key="#{app_key}", oauth_nonce="\S+", oauth_signature="\S+", oauth_signature_method="HMAC-SHA1", oauth_timestamp="\S+", oauth_token="#{app_token}", oauth_version="1.0"/, 'User-Agent'=>'OAuth gem v0.4.7'}).
      to_return(:status => 200, :body => fixture("verify_success"))
      @cli.verify
      expect($stdout.string).to eq <<-eos
Checking credentials with Dropbox...
Connection to dropbox successful!
      eos
    end

    it "returns error string when verify fails" do
      stub_request(:get, "https://api.dropbox.com/1/metadata/dropbox/?").
      with(:headers => {'Accept'=>'*/*', 'Authorization'=> /OAuth oauth_consumer_key="#{app_key}", oauth_nonce="\S+", oauth_signature="\S+", oauth_signature_method="HMAC-SHA1", oauth_timestamp="\S+", oauth_token="#{app_token}", oauth_version="1.0"/, 'User-Agent'=>'OAuth gem v0.4.7'}).
      to_return(:status => 401, :body => "", :headers => {})
      expect { @cli.verify }.to raise_error(SystemExit)
      expect($stdout.string).to eq <<-eos
Checking credentials with Dropbox...
Connection to Dropbox failed (401 - Bad or expired token)
Check your ~/.fallcli/config file, and double check your credentials are correct
      eos
    end

  end

end

