# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::ApplicationSharedContext do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/support/shared_contexts/application.rb" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_rspec: true }

      it "builds file" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          RSpec.shared_context "with application" do
            let(:app) { Hanami.app }
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
