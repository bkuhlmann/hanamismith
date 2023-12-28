# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Javascript do
  using Refinements::Struct

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds home slice application JavaScript" do
      expect(temp_dir.join("test/slices/home/assets/js/app.js").read).to eq(
        %(import "../css/app.css";\n)
      )
    end
  end
end
