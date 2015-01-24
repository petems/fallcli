require 'spec_helper'

describe FallCli::Middleware::Base do
  include_context "spec"

  let(:klass)      { described_class }

  describe ".initialize" do
    it "prints a clear line" do
      $stdout.should_receive(:print).with("")
      klass.new({})
    end
  end

end
