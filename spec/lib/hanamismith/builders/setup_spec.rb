# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Setup do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:build_path) { temp_dir.join "test/bin/setup" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_setup: true }

      it "appends script" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "fileutils"
          require "pathname"

          APP_ROOT = Pathname(__dir__).join("..").expand_path

          Runner = lambda do |*arguments, kernel: Kernel|
            kernel.system(*arguments) || kernel.abort("\\nERROR: Command \#{arguments.inspect} failed.")
          end

          FileUtils.chdir APP_ROOT do
            puts "Installing dependencies..."
            Runner.call "bundle install"

            puts "Installing packages..."
            Runner.call "npm install"

            puts "Configurating databases..."
            Runner.call "bin/hanami db create"
            Runner.call "bin/hanami db migrate"
            Runner.call "HANAMI_ENV=test bin/hanami db create"
            Runner.call "HANAMI_ENV=test bin/hanami db migrate"
          end
        CONTENT
      end
    end

    context "when enabled with debug" do
      let(:test_configuration) { configuration.minimize.merge build_setup: true, build_debug: true }

      it "appends script" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "debug"
          require "fileutils"
          require "pathname"

          APP_ROOT = Pathname(__dir__).join("..").expand_path

          Runner = lambda do |*arguments, kernel: Kernel|
            kernel.system(*arguments) || kernel.abort("\\nERROR: Command \#{arguments.inspect} failed.")
          end

          FileUtils.chdir APP_ROOT do
            puts "Installing dependencies..."
            Runner.call "bundle install"

            puts "Installing packages..."
            Runner.call "npm install"

            puts "Configurating databases..."
            Runner.call "bin/hanami db create"
            Runner.call "bin/hanami db migrate"
            Runner.call "HANAMI_ENV=test bin/hanami db create"
            Runner.call "HANAMI_ENV=test bin/hanami db migrate"
          end
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build setup script" do
        builder.call
        expect(build_path.exist?).to be(false)
      end
    end
  end
end
