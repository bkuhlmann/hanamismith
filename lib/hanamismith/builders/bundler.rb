# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton with Gemfile configuration.
    class Bundler < Rubysmith::Builders::Bundler
      using Refinements::Struct

      def call
        super

        %i[groups hanami main persistence quality devtest development test].each do |name|
          __send__ :"insert_#{name}"
        end

        remove_zeitwerk
        true
      end

      private

      def insert_groups
        return unless settings.build_minimum

        with_template.append <<~CONTENT
          group :development do
          end

          group :test do
          end
        CONTENT
      end

      def insert_hanami
        with_template.insert_after "source", <<~CONTENT.strip
          gem "hanami", "~> 2.2.0"
          gem "hanami-assets", "~> 2.2.0"
          gem "hanami-controller", "~> 2.2.0"
          gem "hanami-db", "~> 2.2.0"
          gem "hanami-router", "~> 2.2.0"
          gem "hanami-validations", "~> 2.2.0"
          gem "hanami-view", "~> 2.2.0"
        CONTENT
      end

      def insert_main
        with_template.insert_after "source", <<~CONTENT
          gem "dry-monads", "~> 1.6"
          gem "dry-schema", "~> 1.13"
          gem "dry-types", "~> 1.7"
          gem "dry-validation", "~> 1.10"
          gem "htmx", "~> 2.1"
          gem "puma", "~> 6.6"
          gem "rack-attack", "~> 6.7"
        CONTENT
      end

      def insert_persistence
        with_template.insert_after "source", <<~CONTENT

          gem "pg", "~> 1.5"
          gem "rom", "~> 5.4"
          gem "rom-sql", "~> 3.7"
          gem "sequel", "~> 5.89"
        CONTENT
      end

      def insert_quality
        with_template.insert_after(/group :quality/, %(  gem "rubocop-sequel", "~> 0.3"\n))
      end

      def insert_devtest
        with_template.insert_before(/group :development/, <<~CONTENT)

          group :development, :test do
            gem "dotenv", "~> 3.0"
          end

        CONTENT
      end

      def insert_development
        with_template.insert_after(/group :development do/, <<~CONTENT.gsub("gem", "  gem"))
          gem "hanami-webconsole", "~> 2.2.0"
          gem "localhost", "~> 1.2"
          gem "rerun", "~> 0.14"
        CONTENT
      end

      def insert_test
        with_template.insert_after(/group :test/, <<~CONTENT.gsub("gem", "  gem"))
          gem "capybara", "~> 3.40"
          gem "cuprite", "~> 0.15"
          gem "database_cleaner-sequel", "~> 2.0"
          gem "launchy", "~> 3.0"
          gem "rack-test", "~> 2.1"
          gem "rom-factory", "~> 0.12"
        CONTENT
      end

      def remove_zeitwerk = with_template.replace(/.+zeitwerk.+\n\n/, "\n")

      def with_template
        builder.call settings.merge(template_path: "%project_name%/Gemfile.erb")
      end
    end
  end
end
