# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Hanami do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_rspec: true }

      it "builds file" do
        builder.call

        expect(temp_dir.join("test/spec/hanami_helper.rb").read).to eq(<<~CONTENT)
          require "capybara/cuprite"
          require "capybara/rspec"
          require "database_cleaner/sequel"
          require "rack/test"
          require "spec_helper"

          ENV["HANAMI_ENV"] = "test"

          require "hanami/prepare"
          require_relative "support/database"
          require_relative "support/factory"

          using Refinements::Pathname

          ENV["LD_PRELOAD"] = nil
          Capybara.app = Hanami.app
          Capybara.server = :puma, {Silent: true, Threads: "0:1"}
          Capybara.javascript_driver = :cuprite
          Capybara.save_path = Hanami.app.root.join "tmp/capybara"
          Capybara.register_driver :cuprite do |app|
            browser_options = {"disable-gpu" => nil, "disable-dev-shm-usage" => nil, "no-sandbox" => nil}
            Capybara::Cuprite::Driver.new app, browser_options:, window_size: [1920, 1080]
          end

          DatabaseCleaner[:sequel].strategy = :transaction

          Pathname.require_tree SPEC_ROOT.join("support/factories")

          RSpec.configure do |config|
            config.include Capybara::DSL, Capybara::RSpecMatchers, :web
            config.include Rack::Test::Methods, type: :request
            config.include Test::Database, :db
            config.include_context "with Hanami application", type: :request

            config.before :suite do
              Hanami.app.start :persistence
              DatabaseCleaner[:sequel].clean_with :truncation
            end

            config.prepend_before :each, :db do |example|
              DatabaseCleaner[:sequel].strategy = example.metadata[:js] ? :truncation : :transaction
              DatabaseCleaner[:sequel].start
            end

            config.append_after(:each, :db) { DatabaseCleaner[:sequel].clean }
          end
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.join("test/spec/hanami_helper.rb").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
