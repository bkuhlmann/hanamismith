# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Providers::Logger do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    before { Hanamismith::Builders::Core.new(settings:, logger:).call }

    it "builds provider implementation" do
      builder.call
      expect(temp_dir.join("test/app/providers/logger.rb").read).to include("module Test")
    end

    it "builds provider specification" do
      builder.call

      expect(temp_dir.join("test/spec/app/providers/logger_spec.rb").read).to eq(
        SPEC_ROOT.join("support/fixtures/specs/logger.txt").read
      )
    end

    it "builds provider registration" do
      builder.call

      expect(temp_dir.join("test/config/providers/logger.rb").read).to eq(<<~CONTENT)
        require_relative "../../app/providers/logger"

        Hanami.app.register_provider :logger, source: Test::Providers::Logger
      CONTENT
    end

    it "builds universal logging patch initializer" do
      builder.call
      expect(temp_dir.join("test/config/initializers/universal_logger_patch.rb").exist?).to be(true)
    end

    it "add initializers" do
      builder.call

      expect(temp_dir.join("test/config/app.rb").read).to include(<<~REQUIRES)
        require "hanami"

        require_relative "initializers/universal_logger_patch"
      REQUIRES
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
