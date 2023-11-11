# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rack::Deflater do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:test_configuration) { configuration.minimize }

  before do
    Hanamismith::Builders::Core.call test_configuration
    Hanamismith::Builders::Rack::Attack.call test_configuration
  end

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "adds middleware to application configuration" do
      expect(temp_dir.join("test/config/app.rb").read).to eq(<<~CONTENT)
        require "hanami"

        require_relative "initializers/rack_attack"

        module Test
          # Defines global application configuration.
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
  end
end
