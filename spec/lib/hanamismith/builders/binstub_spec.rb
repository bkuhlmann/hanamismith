# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Binstub do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:binstub_path) { temp_dir.join "test/bin/hanami" }

    before { builder.call }

    it "builds binstub" do
      expect(binstub_path.read).to eq(<<~CONTENT)
        #! /usr/bin/env ruby

        require "bundler/setup"
        require "hanami/cli"

        Hanami::CLI.tap do |cli|
          cli.register "db create", Hanami::CLI::Commands::App::DB::Create
          cli.register "db create_migration", Hanami::CLI::Commands::App::DB::CreateMigration
          cli.register "db drop", Hanami::CLI::Commands::App::DB::Drop
          cli.register "db migrate", Hanami::CLI::Commands::App::DB::Migrate
          cli.register "db setup", Hanami::CLI::Commands::App::DB::Setup
          cli.register "db reset", Hanami::CLI::Commands::App::DB::Reset
          cli.register "db rollback", Hanami::CLI::Commands::App::DB::Rollback
          cli.register "db seed", Hanami::CLI::Commands::App::DB::Seed
          cli.register "db structure dump", Hanami::CLI::Commands::App::DB::Structure::Dump
          cli.register "db version", Hanami::CLI::Commands::App::DB::Version
        end

        Hanami::CLI::Bundler.require :cli
        Dry::CLI.new(Hanami::CLI).call
      CONTENT
    end

    it "updates file permissions" do
      builder.call
      expect(binstub_path.stat.mode).to eq(33261)
    end
  end
end
