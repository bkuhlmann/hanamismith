# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Bundler do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "with minimum flags" do
      before { settings.merge! settings.minimize }

      it "updates Gemfile" do
        builder.call

        expect(temp_dir.join("test", "Gemfile").read).to eq(<<~CONTENT)
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "pg", "~> 1.5"
          gem "rom", "~> 5.4"
          gem "rom-sql", "~> 3.7"
          gem "sequel", "~> 5.89"
          gem "dry-schema", "~> 1.13"
          gem "dry-types", "~> 1.7"
          gem "dry-validation", "~> 1.10"
          gem "htmx", "~> 2.1"
          gem "overmind", "~> 2.5"
          gem "puma", "~> 6.6"
          gem "rack-attack", "~> 6.7"
          gem "hanami", "~> 2.2.0"
          gem "hanami-assets", "~> 2.2.0"
          gem "hanami-controller", "~> 2.2.0"
          gem "hanami-db", "~> 2.2.0"
          gem "hanami-router", "~> 2.2.0"
          gem "hanami-validations", "~> 2.2.0"
          gem "hanami-view", "~> 2.2.0"

          group :development, :test do
            gem "dotenv", "~> 3.1"
          end

          group :development do
            gem "hanami-webconsole", "~> 2.2.0"
            gem "localhost", "~> 1.3"
            gem "rerun", "~> 0.14"
          end

          group :test do
            gem "capybara", "~> 3.40"
            gem "capybara-validate_html5", "~> 2.1"
            gem "cuprite", "~> 0.15"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "launchy", "~> 3.1"
            gem "rack-test", "~> 2.2"
            gem "rom-factory", "~> 0.13"
          end
        CONTENT
      end
    end

    context "with maximum flags" do
      before { settings.merge! settings.maximize }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "pg", "~> 1.5"
          gem "rom", "~> 5.4"
          gem "rom-sql", "~> 3.7"
          gem "sequel", "~> 5.89"
          gem "dry-schema", "~> 1.13"
          gem "dry-types", "~> 1.7"
          gem "dry-validation", "~> 1.10"
          gem "htmx", "~> 2.1"
          gem "overmind", "~> 2.5"
          gem "puma", "~> 6.6"
          gem "rack-attack", "~> 6.7"
          gem "hanami", "~> 2.2.0"
          gem "hanami-assets", "~> 2.2.0"
          gem "hanami-controller", "~> 2.2.0"
          gem "hanami-db", "~> 2.2.0"
          gem "hanami-router", "~> 2.2.0"
          gem "hanami-validations", "~> 2.2.0"
          gem "hanami-view", "~> 2.2.0"
          gem "bootsnap", "~> 1.18"
          gem "dry-monads", "~> 1.8"
          gem "refinements", "~> 13.0"

          group :quality do
            gem "rubocop-sequel", "~> 0.4"
            gem "caliber", "~> 0.79"
            gem "git-lint", "~> 9.0"
            gem "reek", "~> 6.5", require: false
            gem "simplecov", "~> 0.22", require: false
          end


          group :development, :test do
            gem "dotenv", "~> 3.1"
          end

          group :development do
            gem "hanami-webconsole", "~> 2.2.0"
            gem "localhost", "~> 1.3"
            gem "rerun", "~> 0.14"
            gem "rake", "~> 13.2"
          end

          group :test do
            gem "capybara", "~> 3.40"
            gem "capybara-validate_html5", "~> 2.1"
            gem "cuprite", "~> 0.15"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "launchy", "~> 3.1"
            gem "rack-test", "~> 2.2"
            gem "rom-factory", "~> 0.13"
            gem "rspec", "~> 3.13"
          end

          group :tools do
            gem "amazing_print", "~> 1.8"
            gem "debug", "~> 1.10"
            gem "irb-kit", "~> 1.1"
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
