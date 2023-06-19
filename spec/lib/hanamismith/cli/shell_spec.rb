# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::CLI::Shell do
  using Refinements::Pathnames
  using Refinements::Structs
  using Infusible::Stub

  subject(:shell) { described_class.new }

  include_context "with application dependencies"

  before { Sod::Import.stub kernel:, logger: }

  after { Sod::Import.unstub :kernel, :logger }

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

    it "prints configuration usage" do
      shell.call %w[config]
      expect(kernel).to have_received(:puts).with(/Manage configuration.+/m)
    end

    context "with minimum forced build" do
      let(:options) { %w[build --name test --min] }

      it "builds minimum skeleton" do
        pending "Requires additional Rubysmith support. Workaround: Run in isolation."

        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }
        expect(project_files).to match_array(bom_minimum)
      end
    end

    context "with minimum optional build" do
      let :options do
        SPEC_ROOT.join("support/fixtures/arguments/minimum.txt").readlines chomp: true
      end

      it "builds minimum skeleton" do
        pending "Requires additional Rubysmith support. Workaround: Run in isolation."

        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }
        expect(project_files).to match_array(bom_minimum)
      end
    end

    context "with maximum forced build" do
      let(:options) { %w[build --name test --max] }

      it "builds maximum skeleton" do
        pending "Requires additional Rubysmith support. Workaround: Run in isolation."

        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }
        expect(project_files).to match_array(bom_maximum)
      end
    end

    context "with maximum optional build" do
      let :options do
        SPEC_ROOT.join("support/fixtures/arguments/maximum.txt").readlines chomp: true
      end

      it "builds maximum skeleton" do
        pending "Requires additional Rubysmith support. Workaround: Run in isolation."

        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to match_array(bom_maximum)
        end
      end
    end

    it "prints version" do
      shell.call %w[--version]
      expect(kernel).to have_received(:puts).with(/Hanamismith\s\d+\.\d+\.\d+/)
    end

    it "prints help" do
      shell.call %w[--help]
      expect(kernel).to have_received(:puts).with(/Hanamismith.+USAGE.+/m)
    end
  end
end
