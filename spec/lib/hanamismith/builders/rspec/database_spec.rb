# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Database do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/support/database.rb" }

    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      it "adds database configuration" do
        expect(path.read).to eq(<<~CONTENT)
          module Test
            # Provides convenience methods for testing purposes.
            module Database
              def self.relations = rom.relations

              def self.rom = Hanami.app["persistence.rom"]

              def self.db = Hanami.app["persistence.db"]
            end
          end
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't add database configuration" do
        expect(temp_dir.join(path).exist?).to be(false)
      end
    end
  end
end
