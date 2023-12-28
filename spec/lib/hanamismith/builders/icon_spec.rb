# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Icon do
  using Refinements::Struct

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds stylesheet" do
      expect(temp_dir.join("test/app/assets/images/icon.svg").exist?).to be(true)
    end
  end
end
