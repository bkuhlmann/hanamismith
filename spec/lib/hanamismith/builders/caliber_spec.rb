# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Caliber do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_caliber: true }

      it "updates RuboCop configuration" do
        expect(temp_dir.join("test/.rubocop.yml").read).to eq(<<~CONTENT)
          inherit_gem:
            caliber: config/all.yml

          require: rubocop-sequel
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't create RuboCop configuration" do
        expect(temp_dir.join("test/.rubocop.yml").exist?).to be(false)
      end
    end
  end
end
