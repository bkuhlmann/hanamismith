# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::ApplicationSharedContext do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/support/shared_contexts/application.rb" }

    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      it "adds shared context" do
        expect(path.read).to eq(<<~CONTENT)
          RSpec.shared_context "with Hanami application" do
            let(:app) { Hanami.app }
          end
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't add shared context" do
        expect(temp_dir.join(path).exist?).to be(false)
      end
    end
  end
end
