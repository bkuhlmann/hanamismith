# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Extensions::NPM do
  using Refinements::Pathname

  subject(:extension) { described_class.new settings: }

  include_context "with application dependencies"

  before { temp_dir.join("test").make_path }

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

    it "answers true" do
      expect(extension.call).to be(true)
    end
  end
end
