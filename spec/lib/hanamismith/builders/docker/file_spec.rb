# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Docker::File do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test", "Dockerfile" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_docker: true }

      it "includes production environment" do
        builder.call
        expect(path.read).to include("ENV HANAMI_ENV=production\n")
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
