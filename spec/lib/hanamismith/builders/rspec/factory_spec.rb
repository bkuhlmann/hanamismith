# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Factory do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/support/factory.rb" }

    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      it "adds factory configuration" do
        expect(path.read).to eq(<<~CONTENT)
          require "rom-factory"
          require_relative "database"

          module Test
            Factory = ROM::Factory.configure { |config| config.rom = Test::Database.rom }
          end
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't add factory configuration" do
        expect(temp_dir.join(path).exist?).to be(false)
      end
    end
  end
end
