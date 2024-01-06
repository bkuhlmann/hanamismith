# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Documentation::Readme do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with Markdown format" do
      let :test_configuration do
        configuration.minimize.merge build_readme: true, documentation_format: "md"
      end

      it "builds README" do
        expect(temp_dir.join("test", "README.md").read).to eq(
          SPEC_ROOT.join("support/fixtures/proofs/readme.md").read
        )
      end
    end

    context "when enabled with ASCII Doc format" do
      let :test_configuration do
        configuration.minimize.merge build_readme: true, documentation_format: "adoc"
      end

      it "builds README" do
        expect(temp_dir.join("test", "README.adoc").read).to eq(
          SPEC_ROOT.join("support/fixtures/proofs/readme.adoc").read
        )
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build README" do
        expect(temp_dir.join("test", "README.adoc").exist?).to be(false)
      end
    end
  end
end
