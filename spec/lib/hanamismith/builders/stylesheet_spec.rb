# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Stylesheet do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds home slice application stylesheet" do
      expect(temp_dir.join("test/slices/home/assets/css/app.css").exist?).to be(true)
    end
  end
end
