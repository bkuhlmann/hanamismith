# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Documentation::Readme do
  using Refinements::Structs

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
        expect(temp_dir.join("test", "README.md").read).to include(
          "[Hanamismith](https://www.alchemists.io/projects/hanamismith)"
        )
      end
    end

    context "when enabled with ASCII Doc format" do
      let :test_configuration do
        configuration.minimize.merge build_readme: true, documentation_format: "adoc"
      end

      it "builds README" do
        expect(temp_dir.join("test", "README.adoc").read).to include(
          "link:https://www.alchemists.io/projects/hanamismith[Hanamismith]"
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
