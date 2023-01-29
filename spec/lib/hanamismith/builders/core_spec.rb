# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Core do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "adds action" do
      expect(temp_dir.join("test/app/action.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        require "hanami/action"

        module Test
          # The application action.
          class Action < Hanami::Action
          end
        end
      CONTENT
    end

    it "adds repository" do
      expect(temp_dir.join("test/app/repository.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        require "rom-repository"

        module Test
          # The application repository.
          class Repository < ROM::Repository::Root
            include Deps[container: "persistence.rom"]
          end
        end
      CONTENT
    end

    it "adds view" do
      expect(temp_dir.join("test/app/view.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        require "erbse"
        require "hanami/view"

        module Test
          # The application view.
          class View < Hanami::View
          end
        end
      CONTENT
    end

    it "adds persistence provider" do
      expect(temp_dir.join("test/config/providers/persistence.rb").read).to eq(<<~CONTENT)
        Hanami.app.register_provider :persistence, namespace: true do
          prepare do
            require "rom-changeset"
            require "rom/core"
            require "rom/sql"

            Sequel.database_timezone = :utc
            Sequel.application_timezone = :local

            configuration = ROM::Configuration.new :sql, target["settings"].database_url

            configuration.plugin :sql, relations: :instrumentation do |plugin_config|
              plugin_config.notifications = target["notifications"]
            end

            configuration.plugin :sql, relations: :auto_restrictions

            register "config", configuration
            register "db", configuration.gateways[:default].connection
          end

          start do
            configuration = target["persistence.config"]
            configuration.auto_registration(
              target.root.join("lib/test/persistence"),
              namespace: "Test::Persistence"
            )

            register "rom", ROM.container(configuration)
          end
        end
      CONTENT
    end

    it "adds application configuration" do
      expect(temp_dir.join("test/config/app.rb").read).to eq(<<~CONTENT)
        require "hanami"

        module Test
          # Handles HTTP requests.
          class App < Hanami::App
            config.actions.content_security_policy[:script_src] = "https://unpkg.com"

            config.middleware.use Rack::Deflater
            config.middleware.use Rack::Static, {urls: %w[/stylesheets javascript], root: "public"}
          end
        end
      CONTENT
    end

    it "adds routes configuration" do
      expect(temp_dir.join("test/config/routes.rb").read).to eq(<<~CONTENT)
        module Test
          # Configures application routes.
          class Routes < Hanami::Routes
            slice(:health, at: "/status") { root to: "show" }
            slice(:main, at: "/") { root to: "home.show" }
          end
        end
      CONTENT
    end

    it "adds settings configuration" do
      expect(temp_dir.join("test/config/settings.rb").read).to eq(<<~CONTENT)
        module Test
          # Configures application settings.
          class Settings < Hanami::Settings
            setting :database_url
          end
        end
      CONTENT
    end

    it "adds types" do
      expect(temp_dir.join("test/lib/test/types.rb").read).to eq(<<~CONTENT)
        require "dry/types"

        module Test
          Types = Dry.Types

          # Defines custom types.
          module Types
            # Add custom types here.
          end
        end
      CONTENT
    end
  end
end
