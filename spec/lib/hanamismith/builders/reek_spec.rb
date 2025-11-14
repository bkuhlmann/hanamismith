# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Reek do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "with minimum flags" do
      before { settings.with! settings.minimize }

      it "doesn't add configuration" do
        builder.call
        expect(temp_dir.join("test/.reek.yml").exist?).to be(false)
      end
    end

    context "with maximum flags" do
      before { settings.with! settings.maximize }

      it "updates configuration" do
        builder.call

        expect(temp_dir.join("test/.reek.yml").read).to eq(<<~CONTENT)
          exclude_paths:
            - tmp
            - vendor

          detectors:
            LongParameterList:
              enabled: false
            TooManyStatements:
              exclude:
                - RackLoggerPatch#prepare_app_providers
            UtilityFunction:
              exclude:
                - SQLLoggerPatch#log_query
        CONTENT
      end
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
