# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Icon do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds file" do
      builder.call
      expect(temp_dir.join("test/app/assets/images/icon.svg").exist?).to be(true)
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
