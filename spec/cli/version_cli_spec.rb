require 'spec_helper'

describe FallCli::CLI do
  include_context "spec"

  describe "version" do
    it "shows the correct version" do

      @cli.options = @cli.options.merge(:version => true)
      @cli.version

      expect($stdout.string.chomp).to eq("FallCli #{FallCli::VERSION.to_s}")
    end
  end
end

