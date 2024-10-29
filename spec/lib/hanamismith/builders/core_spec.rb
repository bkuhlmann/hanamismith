# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Core do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds database relation" do
      builder.call

      expect(temp_dir.join("test/app/db/relation.rb").read).to eq(<<~CONTENT)
        require "hanami/db/relation"

        module Test
          module DB
            # The application database base relation.
            class Relation < Hanami::DB::Relation
            end
          end
        end
      CONTENT
    end

    it "builds database repository" do
      builder.call

      expect(temp_dir.join("test/app/db/repository.rb").read).to eq(<<~CONTENT)
        require "hanami/db/repo"

        module Test
          module DB
            # The application database base repository.
            class Repository < Hanami::DB::Repo
            end
          end
        end
      CONTENT
    end

    it "builds database struct" do
      builder.call

      expect(temp_dir.join("test/app/db/struct.rb").read).to eq(<<~CONTENT)
        require "hanami/db/struct"

        module Test
          module DB
            # The application database base struct.
            class Struct < Hanami::DB::Struct
            end
          end
        end
      CONTENT
    end

    it "builds action" do
      builder.call

      expect(temp_dir.join("test/app/action.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        require "hanami/action"

        module Test
          # The application base action.
          class Action < Hanami::Action
          end
        end
      CONTENT
    end

    it "builds view" do
      builder.call

      expect(temp_dir.join("test/app/view.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        require "hanami/view"

        module Test
          # The application base view.
          class View < Hanami::View
          end
        end
      CONTENT
    end

    it "builds application configuration" do
      builder.call

      expect(temp_dir.join("test/config/app.rb").read).to eq(<<~CONTENT)
        require "hanami"

        module Test
          # The application base configuration.
          class App < Hanami::App
            Dry::Schema.load_extensions :monads
            Dry::Validation.load_extensions :monads

            config.actions.content_security_policy.then do |csp|
              csp[:manifest_src] = "'self'"
              csp[:script_src] += " 'unsafe-eval' 'unsafe-inline' https://unpkg.com/"
            end

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

    it "builds routes configuration" do
      builder.call

      expect(temp_dir.join("test/config/routes.rb").read).to eq(<<~CONTENT)
        module Test
          # The application base routes.
          class Routes < Hanami::Routes
            slice(:health, at: "/up") { root to: "show" }
            slice(:home, at: "/") { root to: "show" }
          end
        end
      CONTENT
    end

    it "builds settings configuration" do
      builder.call

      expect(temp_dir.join("test/config/settings.rb").read).to eq(<<~CONTENT)
        module Test
          # The application base settings.
          class Settings < Hanami::Settings
          end
        end
      CONTENT
    end

    it "builds types" do
      builder.call

      expect(temp_dir.join("test/lib/test/types.rb").read).to eq(<<~CONTENT)
        require "dry/types"

        module Test
          Types = Dry.Types

          # The custom types.
          module Types
          end
        end
      CONTENT
    end

    it "builds migrate directory" do
      builder.call
      expect(temp_dir.join("test/db/migrate").exist?).to be(true)
    end

    it "builds public HTTP 404 error page" do
      builder.call
      expect(temp_dir.join("test/public/404.html").exist?).to be(true)
    end

    it "builds public HTTP 500 error page" do
      builder.call
      expect(temp_dir.join("test/public/500.html").exist?).to be(true)
    end

    it "builds temp directory" do
      builder.call
      expect(temp_dir.join("test/tmp").exist?).to be(true)
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
