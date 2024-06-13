# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Asset do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds stylesheet" do
      builder.call

      expect(temp_dir.join("test/config/assets.js").read).to eq(<<~CONTENT)
        import * as assets from "hanami-assets";

        await assets.run();
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
