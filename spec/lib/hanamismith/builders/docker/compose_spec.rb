# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Docker::Compose do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/compose.yml" }

    context "when enabled" do
      before { settings.build_docker = true }

      it "uses project name for image" do
        builder.call
        expect(path.read).to include(%(name: "test"))
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
