# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Extensions::Asset do
  using Refinements::Pathname

  subject(:extension) { described_class.new settings: }

  include_context "with application dependencies"

  before { temp_dir.join("test").make_path }

  describe "#call" do
    it "compiles application assets" do
      extension.call

      expect(kernel).to have_received(:system).with(
        "node config/assets.js -- --path=app --dest=public/assets > /dev/null 2>&1"
      )
    end

    it "compiles home assets" do
      extension.call

      expect(kernel).to have_received(:system).with(
        "node config/assets.js -- --path=slices/home --dest=public/assets/_home > /dev/null 2>&1"
      )
    end

    it "logs error when compile fails" do
      allow(kernel).to receive(:system).and_return(false)
      extension.call

      expect(logger.reread).to match(/🛑.+Unable to compile assets. Try: `hanami assets compile`./)
    end

    it "answers true" do
      expect(extension.call).to be(true)
    end
  end
end
