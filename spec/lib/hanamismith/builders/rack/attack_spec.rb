# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rack::Attack do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application"

  describe "#call" do
    before do
      settings.merge! settings.minimize
      Hanamismith::Builders::Core.new(settings:, logger:).call
      builder.call
    end

    it "builds initializer" do
      expect(temp_dir.join("test/config/initializers/rack_attack.rb").exist?).to be(true)
    end

    it "adds middleware to application configuration" do
      included = temp_dir.join("test/config/app.rb").read.start_with?(<<~CONTENT)
        require "hanami"

        require_relative "initializers/rack_attack"
      CONTENT

      expect(included).to be(true)
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
