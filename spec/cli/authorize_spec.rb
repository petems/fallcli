require 'spec_helper'

describe FallCli::CLI do
  include_context "spec"

  describe "authorize" do
    before do
      stub_request(:post, "https://www.dropbox.com/1/oauth/request_token").
      with(:headers => {'Accept'=>'*/*', 'Authorization'=>/OAuth oauth_body_hash="\S+", oauth_callback="oob", oauth_consumer_key="foo", oauth_nonce="\S+", oauth_signature="\S+", oauth_signature_method="HMAC-SHA1", oauth_timestamp="\S+", oauth_version="1.0"/, 'Content-Length'=>'0', 'User-Agent'=>'OAuth gem v0.4.7'}).
      to_return(:status => 200, :body => "oauth_token_secret=b9q1n5il4lcc&oauth_token=mh7an9dkrg59")

      stub_request(:post, "https://www.dropbox.com/1/oauth/access_token").
      with(:headers => {'Accept'=>'*/*', 'Authorization'=>/OAuth oauth_body_hash="\S+", oauth_consumer_key="#{app_key}", oauth_nonce="\S+", oauth_signature="\S+", oauth_signature_method="HMAC-SHA1", oauth_timestamp="\S+", oauth_token="\S+", oauth_verifier="\S+", oauth_version="1.0"/, 'Content-Length'=>'0', 'User-Agent'=>'OAuth gem v0.4.7'}).
      to_return(:status => 200, :body => "oauth_token_secret=95grkd9na7hm&oauth_token=ccl4li5n1q9b&uid=100")

      stub_request(:get, "https://api.dropbox.com/1/metadata/dropbox/?").
      with(:headers => {'Accept'=>'*/*', 'Authorization'=>/OAuth oauth_consumer_key="#{app_key}", oauth_nonce="\S+", oauth_signature="\S+", oauth_signature_method="HMAC-SHA1", oauth_timestamp="\S+", oauth_token="\S+", oauth_version="1.0"/, 'User-Agent'=>'OAuth gem v0.4.7'}).
      to_return(:status => 200, :body => fixture("verify_success"))
    end

    it "asks the right questions and saves then checks credentials" do

      $stdout.should_receive(:print).exactly(6).times
      $stdout.should_receive(:print).with("Enter your App key: ")
      $stdin.should_receive(:gets).and_return(app_key)
      $stdout.should_receive(:print).with("Enter your Secret key: ")
      $stdin.should_receive(:gets).and_return(secret_key)
      $stdout.should_receive(:print).with("Once you authorize the app on Dropbox, type yes...  ")
      $stdin.should_receive(:gets).and_return('yes')

      @cli.authorize

      expect($stdout.string).to eq <<-eos
If you dont know your app and secret key, try `fallcli get-keys`
Go to this url and click 'Authorize' to get the token:
https://www.dropbox.com/1/oauth/authorize?oauth_token=mh7an9dkrg59
Credentials saved to ~/.fallcli
Checking credentials with Dropbox...
Connection to dropbox successful!
      eos
   end

 end

end

