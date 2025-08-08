# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Extensions::Asset do
  subject(:extension) { described_class.new settings: }

  include_context "with application"

  before { temp_dir.join("test").mkpath }

  describe "#call" do
    it "compiles application assets" do
      extension.call

      expect(kernel).to have_received(:system).with(
        "node config/assets.js -- --path=app --dest=public/assets > /dev/null 2>&1",
        chdir: settings.project_root
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
