# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Asset do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds stylesheet" do
      expect(temp_dir.join("test/config/assets.js").read).to eq(<<~CONTENT)
        import * as assets from "hanami-assets";

        await assets.run();
      CONTENT
    end
  end
end