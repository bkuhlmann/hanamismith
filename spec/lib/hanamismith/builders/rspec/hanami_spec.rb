# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Hanami do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      it "adds helper" do
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

          using Refinements::Pathnames

          Capybara.app = Hanami.app
          Capybara.server = :puma, {Silent: true}
          Capybara.javascript_driver = :cuprite
          Capybara.save_path = Hanami.app.root.join "tmp/capybara"
          Capybara.register_driver :cuprite do |app|
            Capybara::Cuprite::Driver.new app,
                                          browser_options: {"no-sandbox" => nil},
                                          window_size: [1200, 800]
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
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't add helper" do
        expect(temp_dir.join("test/spec/hanami_helper.rb").exist?).to be(false)
      end
    end
  end
end
