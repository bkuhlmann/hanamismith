# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rack::Deflater do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    before do
      settings.merge! settings.minimize
      Hanamismith::Builders::Core.new(settings:, logger:).call
      Hanamismith::Builders::Rack::Attack.new(settings:, logger:).call
    end

    it "adds middleware to application configuration" do
      builder.call

      expect(temp_dir.join("test/config/app.rb").read).to eq(<<~CONTENT)
        require "hanami"

        require_relative "initializers/rack_attack"

        module Test
          # The application base configuration.
          class App < Hanami::App
            Dry::Schema.load_extensions :monads
            Dry::Validation.load_extensions :monads

            config.actions.content_security_policy.then do |csp|
              csp[:manifest_src] = "'self'"
              csp[:script_src] += " 'unsafe-eval' 'unsafe-inline' https://unpkg.com/"
            end

            config.middleware.use Rack::Attack
            config.middleware.use Rack::Deflater

            environment :development do
              # :nocov:
              config.logger.options[:colorize] = true

              config.logger = config.logger.instance.add_backend(
                colorize: false,
                stream: Hanami.app.root.join("log/development.log")
              )
            end
          end
        end
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
