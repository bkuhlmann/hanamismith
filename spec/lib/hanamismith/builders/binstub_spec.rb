# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Binstub do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/bin/hanami" }

    it "builds file" do
      builder.call

      expect(path.read).to eq(<<~CONTENT)
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
      expect(path.stat.mode).to eq(33261)
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
