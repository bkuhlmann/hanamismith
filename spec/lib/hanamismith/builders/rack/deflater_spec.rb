# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rack::Deflater do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    before do
      settings.with! settings.minimize
      Hanamismith::Builders::Core.new(settings:, logger:).call
      Hanamismith::Builders::Rack::Attack.new(settings:, logger:).call
    end

    it "requires initializer" do
      builder.call

      included = temp_dir.join("test/config/app.rb").read.start_with?(<<~CONTENT)
        require "hanami"

        require_relative "initializers/rack_attack"
      CONTENT

      expect(included).to be(true)
    end

    it "uses middleware" do
      builder.call
      content = temp_dir.join("test/config/app.rb").read

      expect(content).to include("config.middleware.use Rack::Deflater")
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
