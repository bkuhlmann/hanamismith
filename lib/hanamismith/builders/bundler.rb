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
          gem "hanami", "~> 2.3"
          gem "hanami-assets", "~> 2.3"
          gem "hanami-controller", "~> 2.3"
          gem "hanami-db", "~> 2.3"
          gem "hanami-router", "~> 2.3"
          gem "hanami-validations", "~> 2.3"
          gem "hanami-view", "~> 2.3"
        CONTENT
      end

      def insert_main
        with_template.insert_after "source", <<~CONTENT
          gem "dry-schema", "~> 1.14"
          gem "dry-types", "~> 1.8"
          gem "dry-validation", "~> 1.10"
          gem "htmx", "~> 3.0"
          gem "overmind", "~> 2.5"
          gem "puma", "~> 7.0"
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
        with_template.insert_after(/group :quality/, %(  gem "rubocop-sequel", "~> 0.4"\n))
      end

      def insert_devtest
        with_template.insert_before(/group :development/, <<~CONTENT)

          group :development, :test do
            gem "dotenv", "~> 3.1"
          end

        CONTENT
      end

      def insert_development
        with_template.insert_after(/group :development do/, <<~CONTENT.gsub("gem", "  gem"))
          gem "hanami-webconsole", "~> 2.3"
          gem "localhost", "~> 1.3"
        CONTENT
      end

      def insert_test
        with_template.insert_after(/group :test/, <<~CONTENT.gsub("gem", "  gem"))
          gem "capybara", "~> 3.40"
          gem "capybara-validate_html5", "~> 2.1"
          gem "cuprite", "~> 0.15"
          gem "database_cleaner-sequel", "~> 2.0"
          gem "launchy", "~> 3.1"
          gem "rack-test", "~> 2.2"
          gem "rom-factory", "~> 0.13"
        CONTENT
      end

      def remove_zeitwerk = with_template.replace(/.+zeitwerk.+\n\n/, "\n")

      def with_template
        builder.call settings.with(template_path: "%project_name%/Gemfile.erb")
      end
    end
  end
end
