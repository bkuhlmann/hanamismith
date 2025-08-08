# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Stylesheet do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application"

  describe "#call" do
    it "builds home slice file" do
      builder.call
      expect(temp_dir.join("test/app/assets/css/app.css").exist?).to be(true)
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
