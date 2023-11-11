# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Extensions::NPM do
  using Refinements::Pathnames

  subject(:extension) { described_class.new configuration }

  include_context "with application dependencies"

  before { temp_dir.join("test").make_path }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration)).to be_a(Rubysmith::Configuration::Model)
    end
  end

  describe "#call" do
    it "install packages" do
      extension.call
      expect(kernel).to have_received(:system).with("command -v npm && npm install")
    end

    it "logs error when install fails" do
      allow(kernel).to receive(:system).with("command -v npm && npm install").and_return(false)
      extension.call

      expect(logger.reread).to match(
        /🛑.+Unable to detect NPM. Install NPM and run: `npm install`./
      )
    end
  end
end
