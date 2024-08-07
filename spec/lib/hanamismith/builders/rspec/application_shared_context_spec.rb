# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::ApplicationSharedContext do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/support/shared_contexts/application.rb" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_rspec: true }

      it "adds shared context" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          RSpec.shared_context "with Hanami application" do
            let(:app) { Hanami.app }
          end
        CONTENT
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't add shared context" do
        builder.call
        expect(temp_dir.join(path).exist?).to be(false)
      end
    end
  end
end
