# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Providers::Persistence do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "adds configuration" do
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
  end
end
