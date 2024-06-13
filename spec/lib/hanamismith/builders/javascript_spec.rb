# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Javascript do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds home slice application JavaScript" do
      builder.call

      expect(temp_dir.join("test/slices/home/assets/js/app.js").read).to eq(
        %(import "../css/app.css";\n)
      )
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
