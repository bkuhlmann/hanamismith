# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Caliber do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_caliber: true }

      it "updates configuration" do
        builder.call

        expect(temp_dir.join("test/.config/rubocop/config.yml").read).to eq(<<~CONTENT)
          inherit_gem:
            caliber: config/all.yml

          plugins: rubocop-sequel
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.join("test/.rubocop.yml").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
