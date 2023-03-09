# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton with Gemfile configuration.
    class Bundler < Rubysmith::Builders::Bundler
      using Refinements::Structs

      # :reek:TooManyStatements
      def call
        super
        insert_main_dependencies
        insert_persistence_dependencies
        alter_groups
        append_development_group
        append_test_group
        insert_development_and_test_group
        remove_zeitwerk
        configuration
      end

      private

      attr_reader :configuration, :builder

      # rubocop:todo Metrics/MethodLength
      def insert_main_dependencies
        with_template.insert_after("source", %(gem "dry-types", "~> 1.7"))
                     .insert_after("source", %(gem "erbse", "~> 0.1"\n))
                     .insert_after("source", %(gem "hanami", "~> 2.0"\n))
                     .insert_after("source", %(gem "hanami-controller", "~> 2.0"\n))
                     .insert_after(
                       "source",
                       %(gem "hanami-helpers", github: "hanami/helpers", branch: "main"\n)
                     )
                     .insert_after("source", %(gem "hanami-router", "~> 2.0"\n))
                     .insert_after("source", %(gem "hanami-validations", "~> 2.0"\n))
                     .insert_after(
                       "source",
                       %(gem "hanami-view", github: "hanami/view", branch: "main"\n)
                     )
                     .insert_after("source", %(gem "puma", "~> 6.0"\n))
                     .insert_after("source", %(gem "rack-attack", "~> 6.6"\n))
      end
      # rubocop:enable Metrics/MethodLength

      def insert_persistence_dependencies
        with_template.insert_after("source", %(gem "pg", "~> 1.4"\n))
                     .insert_after("source", %(gem "rom", "~> 5.3"\n))
                     .insert_after("source", %(gem "rom-sql", "~> 3.6"\n))
                     .insert_after("source", %(\ngem "sequel", "~> 5.64"\n))
      end

      def alter_groups
        with_template.insert_after(/group :code_quality/, %(  gem "rubocop-sequel", "~> 0.3"\n))
                     .insert_after(/group :development do/, %(  gem "localhost", "~> 1.1"\n))
                     .insert_after(/group :development do/, %(  gem "rerun", "~> 0.14"\n))
                     .insert_after(/group :test/, %(  gem "capybara", "~> 3.38"\n))
                     .insert_after(/group :test/, %(  gem "cuprite", "~> 0.14"\n))
                     .insert_after(/group :test/, %(  gem "database_cleaner-sequel", "~> 2.0"\n))
                     .insert_after(/group :test/, %(  gem "launchy", "~> 2.5"\n))
                     .insert_after(/group :test/, %(  gem "rack-test", "~> 2.0"\n))
                     .insert_after(/group :test/, %(  gem "rom-factory", "~> 0.11"\n))
      end

      def append_development_group
        return if configuration.markdown? || configuration.build_rake || configuration.build_yard

        with_template.append <<~CONTENT
          group :development do
            gem "localhost", "~> 1.1"
            gem "rerun", "~> 0.14"
          end

        CONTENT
      end

      def append_test_group
        return if configuration.build_guard || configuration.build_rspec

        with_template.append <<~CONTENT
          group :test do
            gem "capybara", "~> 3.38"
            gem "cuprite", "~> 0.14"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "hanami-rspec", "~> 2.0"
            gem "launchy", "~> 2.5"
            gem "rack-test", "~> 2.0"
            gem "rom-factory", "~> 0.11"
          end
        CONTENT
      end

      def insert_development_and_test_group
        with_template.insert_before(/group :development/, <<~CONTENT)

          group :development, :test do
            gem "dotenv", "~> 2.8"
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
