# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Factory do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/support/factory.rb" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_rspec: true }

      it "adds factory configuration" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          require "rom-factory"
          require_relative "database"

          module Test
            Factory = ROM::Factory.configure { |config| config.rom = Test::Database.rom }
          end
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't add factory configuration" do
        builder.call
        expect(temp_dir.join(path).exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
