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
          require "capybara-validate_html5"
          require "database_cleaner/sequel"
          require "dry/monads"
          require "rack/test"
          require "rom-factory"
          require "spec_helper"

          ENV["HANAMI_ENV"] = "test"

          require "hanami/prepare"

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

          Pathname.require_tree SPEC_ROOT.join("support/factories")

          RSpec.configure do |config|
            config.include Capybara::DSL, Capybara::RSpecMatchers, :web
            config.include Rack::Test::Methods, type: :request

            config.define_derived_metadata(file_path: %r(/spec/features/)) { it[:type] = :feature }
            config.define_derived_metadata(file_path: %r(/spec/requests/)) { it[:type] = :request }

            config.include_context "with application", type: :request
            config.include_context "with application", type: :feature

            databases = proc do
              Hanami.app.slices.with_nested.prepend(Hanami.app).each.with_object Set.new do |slice, dbs|
                next unless slice.key? "db.rom"

                dbs.merge slice["db.rom"].gateways.values.map(&:connection).to_enum
              end
            end

            config.before :suite do
              databases.call.each do |db|
                DatabaseCleaner[:sequel, db:].clean_with :truncation, except: ["schema_migrations"]
              end
            end

            config.prepend_before :each, :db do |example|
              databases.call.each do |db|
                DatabaseCleaner[:sequel, db:].strategy = example.metadata[:js] ? :truncation : :transaction
                DatabaseCleaner[:sequel, db:].start
              end
            end

            config.append_after :each, :db do
              databases.call.each { |db| DatabaseCleaner[:sequel, db:].clean }
            end
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
