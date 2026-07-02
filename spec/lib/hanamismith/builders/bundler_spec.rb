# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Bundler do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "with minimum flags" do
      before { settings.with! settings.minimize }

      it "updates Gemfile" do
        builder.call

        expect(temp_dir.join("test", "Gemfile").read).to eq(<<~CONTENT)
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "pg", "~> 1.6", force_ruby_platform: true
          gem "rom", "~> 5.4"
          gem "rom-sql", "~> 3.7"
          gem "sequel", "~> 5.106"
          gem "cogger", "~> 2.4"
          gem "core", "~> 3.2"
          gem "dry-schema", "~> 1.16"
          gem "dry-types", "~> 1.9"
          gem "dry-validation", "~> 1.11"
          gem "htmx", "~> 3.2"
          gem "i18n", "~> 1.15"
          gem "puma", "~> 8.0"
          gem "rack-attack", "~> 6.8"
          gem "hanami", "~> 3.0"
          gem "hanami-action", "~> 3.0"
          gem "hanami-assets", "~> 3.0"
          gem "hanami-db", "~> 3.0"
          gem "hanami-mailer", "~> 3.0"
          gem "hanami-router", "~> 3.0"
          gem "hanami-view", "~> 3.0"

          group :development, :test do
            gem "dotenv", "~> 3.2"
          end

          group :development do
            gem "hanami-webconsole", "~> 3.0"
            gem "localhost", "~> 1.8"
          end

          group :test do
            gem "capybara", "~> 3.40"
            gem "capybara-validate_html5", "~> 2.1"
            gem "cuprite", "~> 0.17"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "launchy", "~> 3.1"
            gem "rack-test", "~> 2.2"
            gem "rom-factory", "~> 0.13"
          end
        CONTENT
      end
    end

    context "with maximum flags" do
      before { settings.with! settings.maximize }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "pg", "~> 1.6", force_ruby_platform: true
          gem "rom", "~> 5.4"
          gem "rom-sql", "~> 3.7"
          gem "sequel", "~> 5.106"
          gem "cogger", "~> 2.4"
          gem "core", "~> 3.2"
          gem "dry-schema", "~> 1.16"
          gem "dry-types", "~> 1.9"
          gem "dry-validation", "~> 1.11"
          gem "htmx", "~> 3.2"
          gem "i18n", "~> 1.15"
          gem "puma", "~> 8.0"
          gem "rack-attack", "~> 6.8"
          gem "hanami", "~> 3.0"
          gem "hanami-action", "~> 3.0"
          gem "hanami-assets", "~> 3.0"
          gem "hanami-db", "~> 3.0"
          gem "hanami-mailer", "~> 3.0"
          gem "hanami-router", "~> 3.0"
          gem "hanami-view", "~> 3.0"
          gem "bootsnap", "~> 1.24"
          gem "dry-monads", "~> 1.10"
          gem "refinements", "~> 14.3"

          group :quality do
            gem "rubocop-sequel", "~> 0.4"
            gem "caliber", "~> 0.94"
            gem "git-lint", "~> 11.0"
            gem "reek", "~> 6.5", require: false
            gem "simplecov", "~> 0.22", require: false
          end


          group :development, :test do
            gem "dotenv", "~> 3.2"
          end

          group :development do
            gem "hanami-webconsole", "~> 3.0"
            gem "localhost", "~> 1.8"
            gem "rake", "~> 13.4"
          end

          group :test do
            gem "capybara", "~> 3.40"
            gem "capybara-validate_html5", "~> 2.1"
            gem "cuprite", "~> 0.17"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "launchy", "~> 3.1"
            gem "rack-test", "~> 2.2"
            gem "rom-factory", "~> 0.13"
            gem "rspec", "~> 3.13"
          end

          group :tools do
            gem "amazing_print", "~> 2.0"
            gem "debug", "~> 1.11"
            gem "irb-kit", "~> 2.2"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "updates Gemfile" do
        builder.call
        expect(temp_dir.join("test", "Gemfile").read).to eq(proof)
      end
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
