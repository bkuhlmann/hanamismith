# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::CLI::Shell do
  using Refinements::Pathnames
  using Infusible::Stub

  subject(:shell) { described_class.new }

  include_context "with application dependencies"

  before { Hanamismith::CLI::Actions::Import.stub configuration:, kernel:, logger: }

  after { Hanamismith::CLI::Actions::Import.unstub :configuration, :kernel, :logger }

  describe "#call" do
    let :bom_minimum do
      SPEC_ROOT.join("support/fixtures/boms/minimum.txt")
               .readlines(chomp: true)
               .push(("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"))
               .compact
    end

    let :bom_maximum do
      SPEC_ROOT.join("support/fixtures/boms/maximum.txt")
               .readlines(chomp: true)
               .push(("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"))
               .compact
    end

    let :project_files do
      temp_dir.join("test")
              .files("**/*", flag: File::FNM_DOTMATCH)
              .reject { |path| path.fnmatch?("*git/*") && !path.fnmatch?("*git/HEAD") }
              .reject { |path| path.fnmatch? "*tags" }
              .map { |path| path.relative_path_from(temp_dir).to_s }
    end

    it "edits configuration" do
      shell.call %w[--config edit]
      expect(kernel).to have_received(:system).with("$EDITOR ")
    end

    it "views configuration" do
      shell.call %w[--config view]
      expect(kernel).to have_received(:system).with("cat ")
    end

    context "with minimum forced build" do
      let(:options) { %w[--build test --min] }

      it "builds minimum skeleton" do
        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }

        expect(project_files).to contain_exactly(*bom_minimum)
      end
    end

    context "with minimum optional build" do
      let :options do
        SPEC_ROOT.join("support/fixtures/arguments/minimum.txt").readlines chomp: true
      end

      it "builds minimum skeleton" do
        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }

        expect(project_files).to contain_exactly(*bom_minimum)
      end
    end

    context "with maximum forced build" do
      let(:options) { %w[--build test --max] }

      it "builds maximum skeleton" do
        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }

        expect(project_files).to contain_exactly(*bom_maximum)
      end
    end

    context "with maximum optional build" do
      let :options do
        SPEC_ROOT.join("support/fixtures/arguments/maximum.txt").readlines chomp: true
      end

      it "builds maximum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to contain_exactly(*bom_maximum)
        end
      end
    end

    it "prints version" do
      shell.call %w[--version]
      expect(logger.reread).to match(/Hanamismith\s\d+\.\d+\.\d+/)
    end

    it "prints help (usage)" do
      shell.call %w[--help]
      expect(logger.reread).to match(/Hanamismith.+USAGE.+/m)
    end

    it "prints usage when no options are given" do
      shell.call
      expect(logger.reread).to match(/Hanamismith.+USAGE.+/m)
    end

    it "prints error with invalid option" do
      shell.call %w[--bogus]
      expect(logger.reread).to match(/invalid option.+bogus/)
    end
  end
end
