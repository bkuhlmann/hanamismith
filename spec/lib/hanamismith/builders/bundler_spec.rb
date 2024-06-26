# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Bundler do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with minimum flags" do
      let(:test_configuration) { configuration.minimize }

      it "updates Gemfile" do
        expect(temp_dir.join("test", "Gemfile").read).to eq(<<~CONTENT)
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "pg", "~> 1.5"
          gem "rom", "~> 5.3"
          gem "rom-sql", "~> 3.6"
          gem "sequel", "~> 5.77"
          gem "dry-monads", "~> 1.6"
          gem "dry-schema", "~> 1.13"
          gem "dry-types", "~> 1.7"
          gem "dry-validation", "~> 1.10"
          gem "htmx", "~> 1.0"
          gem "puma", "~> 6.4"
          gem "rack-attack", "~> 6.7"
          gem "hanami", "~> 2.1"
          gem "hanami-assets", "~> 2.1"
          gem "hanami-cli", "~> 2.1"
          gem "hanami-controller", "~> 2.1"
          gem "hanami-router", "~> 2.1"
          gem "hanami-validations", "~> 2.1"
          gem "hanami-view", "~> 2.1"

          group :development, :test do
            gem "dotenv", "~> 3.0"
          end

          group :development do
            gem "hanami-webconsole", "~> 2.1"
            gem "localhost", "~> 1.2"
            gem "rerun", "~> 0.14"
          end

          group :test do
            gem "capybara", "~> 3.40"
            gem "cuprite", "~> 0.15"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "launchy", "~> 3.0"
            gem "rack-test", "~> 2.1"
            gem "rom-factory", "~> 0.12"
          end
        CONTENT
      end
    end

    context "with maximum flags" do
      let(:test_configuration) { configuration.maximize }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "pg", "~> 1.5"
          gem "rom", "~> 5.3"
          gem "rom-sql", "~> 3.6"
          gem "sequel", "~> 5.77"
          gem "dry-monads", "~> 1.6"
          gem "dry-schema", "~> 1.13"
          gem "dry-types", "~> 1.7"
          gem "dry-validation", "~> 1.10"
          gem "htmx", "~> 1.0"
          gem "puma", "~> 6.4"
          gem "rack-attack", "~> 6.7"
          gem "hanami", "~> 2.1"
          gem "hanami-assets", "~> 2.1"
          gem "hanami-cli", "~> 2.1"
          gem "hanami-controller", "~> 2.1"
          gem "hanami-router", "~> 2.1"
          gem "hanami-validations", "~> 2.1"
          gem "hanami-view", "~> 2.1"
          gem "refinements", "~> 12.1"

          group :quality do
            gem "rubocop-sequel", "~> 0.3"
            gem "caliber", "~> 0.58"
            gem "git-lint", "~> 7.3"
            gem "reek", "~> 6.3", require: false
            gem "simplecov", "~> 0.22", require: false
          end


          group :development, :test do
            gem "dotenv", "~> 3.0"
          end

          group :development do
            gem "hanami-webconsole", "~> 2.1"
            gem "localhost", "~> 1.2"
            gem "rerun", "~> 0.14"
            gem "rake", "~> 13.2"
          end

          group :test do
            gem "capybara", "~> 3.40"
            gem "cuprite", "~> 0.15"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "launchy", "~> 3.0"
            gem "rack-test", "~> 2.1"
            gem "rom-factory", "~> 0.12"
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.13"
          end

          group :tools do
            gem "amazing_print", "~> 1.6"
            gem "debug", "~> 1.9"
            gem "irb-kit", "~> 0.0"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "updates Gemfile" do
        expect(temp_dir.join("test", "Gemfile").read).to eq(proof)
      end
    end
  end
end
