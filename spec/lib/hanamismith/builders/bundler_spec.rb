# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Bundler do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with minimum flags" do
      let(:test_configuration) { configuration.minimize }

      it "updates Gemfile" do
        expect(temp_dir.join("test", "Gemfile").read).to eq(<<~CONTENT)
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "sequel", "~> 5.68"
          gem "rom-sql", "~> 3.6"
          gem "rom", "~> 5.3"
          gem "pg", "~> 1.5"
          gem "rack-attack", "~> 6.6"
          gem "puma", "~> 6.3"
          gem "htmx", "~> 0.1"
          gem "hanami-view", github: "hanami/view", branch: "main"
          gem "hanami-validations", github: "hanami/validations", branch: "main"
          gem "hanami-router", github: "hanami/router", branch: "main"
          gem "hanami-controller", github: "hanami/controller", branch: "main"
          gem "hanami", github: "hanami/hanami", branch: "main"
          gem "dry-types", "~> 1.7"

          group :development, :test do
            gem "dotenv", "~> 2.8"
          end

          group :development do
            gem "localhost", "~> 1.1"
            gem "rerun", "~> 0.14"
          end

          group :test do
            gem "capybara", "~> 3.39"
            gem "cuprite", "~> 0.14"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "hanami-rspec", "~> 2.0"
            gem "launchy", "~> 2.5"
            gem "rack-test", "~> 2.1"
            gem "rom-factory", "~> 0.11"
          end
        CONTENT
      end
    end

    context "with maximum flags" do
      let(:test_configuration) { configuration.maximize }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "sequel", "~> 5.68"
          gem "rom-sql", "~> 3.6"
          gem "rom", "~> 5.3"
          gem "pg", "~> 1.5"
          gem "rack-attack", "~> 6.6"
          gem "puma", "~> 6.3"
          gem "htmx", "~> 0.1"
          gem "hanami-view", github: "hanami/view", branch: "main"
          gem "hanami-validations", github: "hanami/validations", branch: "main"
          gem "hanami-router", github: "hanami/router", branch: "main"
          gem "hanami-controller", github: "hanami/controller", branch: "main"
          gem "hanami", github: "hanami/hanami", branch: "main"
          gem "dry-types", "~> 1.7"
          gem "refinements", "~> 11.0"

          group :code_quality do
            gem "rubocop-sequel", "~> 0.3"
            gem "caliber", "~> 0.35"
            gem "git-lint", "~> 5.0"
            gem "reek", "~> 6.1", require: false
            gem "simplecov", "~> 0.22", require: false
          end


          group :development, :test do
            gem "dotenv", "~> 2.8"
          end

          group :development do
            gem "rerun", "~> 0.14"
            gem "localhost", "~> 1.1"
            gem "asciidoctor", "~> 2.0"
            gem "rake", "~> 13.0"
            gem "yard", "~> 0.9"
          end

          group :test do
            gem "rom-factory", "~> 0.11"
            gem "rack-test", "~> 2.1"
            gem "launchy", "~> 2.5"
            gem "database_cleaner-sequel", "~> 2.0"
            gem "cuprite", "~> 0.14"
            gem "capybara", "~> 3.39"
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.12"
          end

          group :tools do
            gem "amazing_print", "~> 1.4"
            gem "debug", "~> 1.8"
          end
        CONTENT
      end

      it "updates Gemfile" do
        expect(temp_dir.join("test", "Gemfile").read).to eq(proof)
      end
    end
  end
end
