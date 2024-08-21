# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Documentation::Readme do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "when enabled with ASCII Doc format" do
      before do
        settings.merge! settings.minimize.merge build_readme: true, documentation_format: "adoc"
      end

      it "builds file" do
        builder.call

        expect(temp_dir.join("test", "README.adoc").read).to include(
          "link:https://alchemists.io/projects/hanamismith[Hanamismith]"
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with Markdown format" do
      before do
        settings.merge! settings.minimize.merge build_readme: true, documentation_format: "md"
      end

      it "builds file" do
        builder.call

        expect(temp_dir.join("test", "README.md").read).to include(
          "[Hanamismith](https://alchemists.io/projects/hanamismith)"
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.join("test", "README.adoc").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
