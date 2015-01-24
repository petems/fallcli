require 'spec_helper'

describe FallCli::CLI do
  include_context "spec"

  describe "account" do
    it "returns account info" do

      stub_request(:get, "https://api.dropbox.com/1/account/info?").
         with(:headers => {'Accept'=>'*/*', 'Authorization'=>/OAuth oauth_consumer_key="#{app_key}", oauth_nonce="\S+", oauth_signature="\S+", oauth_signature_method="HMAC-SHA1", oauth_timestamp="\S+", oauth_token="#{app_token}", oauth_version="1.0"/, 'User-Agent'=>'OAuth gem v0.4.7'}).
         to_return(:status => 200, :body => fixture('account'))

      @cli.account
      expect($stdout.string).to eq <<-eos
REFERRAL_LINK                  | DISPLAY_NAME | UID      | COUNTRY | QUOTA_INFO
-------------------------------|--------------|----------|---------|-------------------------------
https://www.dropbox.com/ref... | John P. User | 12345678 | US      | #<Dropbox::API::Object norm...
      eos
    end

  end

end

