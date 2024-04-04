# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton with Gemfile configuration.
    class Bundler < Rubysmith::Builders::Bundler
      using Refinements::Struct

      # :reek:TooManyStatements
      def call
        super
        insert_main_dependencies
        insert_persistence_dependencies
        alter_groups
        insert_development_group
        insert_test_group
        insert_development_and_test_group
        remove_zeitwerk
        configuration
      end

      private

      attr_reader :configuration, :builder

      # rubocop:todo Metrics/MethodLength
      def insert_main_dependencies
        with_template.insert_after("source", %(gem "dry-monads", "~> 1.6"))
                     .insert_after("source", %(gem "dry-schema", "~> 1.13"\n))
                     .insert_after("source", %(gem "dry-types", "~> 1.7"\n))
                     .insert_after("source", %(gem "dry-validation", "~> 1.10"\n))
                     .insert_after("source", %(gem "hanami", "~> 2.1"\n))
                     .insert_after("source", %(gem "hanami-assets", "~> 2.1"\n))
                     .insert_after("source", %(gem "hanami-cli", "~> 2.1"\n))
                     .insert_after("source", %(gem "hanami-controller", "~> 2.1"\n))
                     .insert_after("source", %(gem "hanami-router", "~> 2.1"\n))
                     .insert_after("source", %(gem "hanami-validations", "~> 2.1"\n))
                     .insert_after("source", %(gem "hanami-view", "~> 2.1"\n))
                     .insert_after("source", %(gem "htmx", "~> 1.0"\n))
                     .insert_after("source", %(gem "puma", "~> 6.4"\n))
                     .insert_after("source", %(gem "rack-attack", "~> 6.7"\n))
      end
      # rubocop:enable Metrics/MethodLength

      def insert_persistence_dependencies
        with_template.insert_after("source", %(gem "pg", "~> 1.5"\n))
                     .insert_after("source", %(gem "rom", "~> 5.3"\n))
                     .insert_after("source", %(gem "rom-sql", "~> 3.6"\n))
                     .insert_after("source", %(\ngem "sequel", "~> 5.77"\n))
      end

      # rubocop:todo Metrics/MethodLength
      def alter_groups
        with_template.insert_after(/group :quality/, %(  gem "rubocop-sequel", "~> 0.3"\n))
                     .insert_after(
                       /group :development do/,
                       %(  gem "hanami-webconsole", "~> 2.1"\n)
                     )
                     .insert_after(/group :development do/, %(  gem "localhost", "~> 1.2"\n))
                     .insert_after(/group :development do/, %(  gem "rerun", "~> 0.14"\n))
                     .insert_after(/group :test/, %(  gem "capybara", "~> 3.40"\n))
                     .insert_after(/group :test/, %(  gem "cuprite", "~> 0.15"\n))
                     .insert_after(/group :test/, %(  gem "database_cleaner-sequel", "~> 2.0"\n))
                     .insert_after(/group :test/, %(  gem "launchy", "~> 3.0"\n))
                     .insert_after(/group :test/, %(  gem "rack-test", "~> 2.1"\n))
                     .insert_after(/group :test/, %(  gem "rom-factory", "~> 0.12"\n))
      end
      # rubocop:enable Metrics/MethodLength

      def insert_development_group
        return if configuration.markdown? || configuration.build_rake

        with_template.insert_before(/group :tools do/, <<~CONTENT)
          group :development do
            gem "hanami-webconsole", "~> 2.1"
            gem "localhost", "~> 1.2"
            gem "rerun", "~> 0.14"
          end

        CONTENT
      end

      # rubocop:todo Metrics/MethodLength
      def insert_test_group
        return if configuration.build_guard || configuration.build_rspec

        with_template.insert_before(/group :tools do/, <<~CONTENT)
          group :test do
            gem "capybara", "~> 3.40"
            gem "cuprite", "~> 0.15"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "hanami-rspec", "~> 2.1"
            gem "launchy", "~> 3.0"
            gem "rack-test", "~> 2.1"
            gem "rom-factory", "~> 0.12"
          end

        CONTENT
      end
      # rubocop:enable Metrics/MethodLength

      def insert_development_and_test_group
        with_template.insert_before(/group :development/, <<~CONTENT)

          group :development, :test do
            gem "dotenv", "~> 3.0"
          end

        CONTENT
      end

      def remove_zeitwerk = with_template.replace(/.+zeitwerk.+\n\n/, "\n")

      def with_template
        builder.call configuration.merge(template_path: "%project_name%/Gemfile.erb")
      end
    end
  end
end
