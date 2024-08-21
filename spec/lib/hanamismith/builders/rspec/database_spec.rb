# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Database do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/support/database.rb" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_rspec: true }

      it "builds file" do
        builder.call

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

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.join(path).exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
