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

      let :files do
        [
          "test/.envrc",
          "test/.ruby-version",
          "test/app/action.rb",
          "test/app/repo.rb",
          "test/app/view.rb",
          "test/bin/hanami",
          "test/config.ru",
          "test/config/app.rb",
          "test/config/providers/persistence.rb",
          "test/config/puma.rb",
          "test/config/routes.rb",
          "test/config/settings.rb",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"),
          "test/lib/test/types.rb",
          "test/Procfile",
          "test/Procfile.dev",
          "test/slices/main/action.rb",
          "test/slices/main/actions/home/show.rb",
          "test/slices/main/repo.rb",
          "test/slices/main/templates/home/show.html.erb",
          "test/slices/main/templates/layouts/app.html.erb",
          "test/slices/main/view.rb",
          "test/slices/main/views/home/show.rb"
        ].compact
      end

      it "builds minimum skeleton" do
        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }

        expect(project_files).to contain_exactly(*files)
      end
    end

    context "with minimum optional build" do
      let :options do
        %w[
          --build
          test
          --no-amazing_print
          --no-caliber
          --no-circle_ci
          --no-citation
          --no-community
          --no-conduct
          --no-console
          --no-contributions
          --no-debug
          --no-funding
          --no-git
          --no-git_hub
          --no-git_hub_ci
          --no-git-lint
          --no-guard
          --no-license
          --no-rake
          --no-readme
          --no-reek
          --no-refinements
          --no-rspec
          --no-setup
          --no-security
          --no-simple_cov
          --no-versions
          --no-zeitwerk
        ]
      end

      let :files do
        [
          "test/.envrc",
          "test/.ruby-version",
          "test/bin/hanami",
          "test/app/action.rb",
          "test/app/repo.rb",
          "test/app/view.rb",
          "test/config.ru",
          "test/config/app.rb",
          "test/config/providers/persistence.rb",
          "test/config/puma.rb",
          "test/config/routes.rb",
          "test/config/settings.rb",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"),
          "test/lib/test/types.rb",
          "test/Procfile",
          "test/Procfile.dev",
          "test/slices/main/action.rb",
          "test/slices/main/actions/home/show.rb",
          "test/slices/main/repo.rb",
          "test/slices/main/templates/home/show.html.erb",
          "test/slices/main/templates/layouts/app.html.erb",
          "test/slices/main/view.rb",
          "test/slices/main/views/home/show.rb"
        ].compact
      end

      it "builds minimum skeleton" do
        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }

        expect(project_files).to contain_exactly(*files)
      end
    end

    context "with maximum forced build" do
      let(:options) { %w[--build test --max] }

      let :files do
        [
          "test/.envrc",
          "test/.circleci/config.yml",
          "test/.git/HEAD",
          "test/.github/FUNDING.yml",
          "test/.github/ISSUE_TEMPLATE.md",
          "test/.github/PULL_REQUEST_TEMPLATE.md",
          "test/.github/workflows/ci.yml",
          "test/.gitignore",
          "test/.reek.yml",
          "test/.rubocop.yml",
          "test/.ruby-version",
          "test/config.ru",
          "test/app/action.rb",
          "test/app/repo.rb",
          "test/app/view.rb",
          "test/bin/console",
          "test/bin/guard",
          "test/bin/hanami",
          "test/bin/rspec",
          "test/bin/rubocop",
          "test/bin/setup",
          "test/CITATION.cff",
          "test/config/app.rb",
          "test/config/providers/persistence.rb",
          "test/config/puma.rb",
          "test/config/routes.rb",
          "test/config/settings.rb",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"),
          "test/Guardfile",
          "test/lib/test/types.rb",
          "test/LICENSE.adoc",
          "test/Procfile",
          "test/Procfile.dev",
          "test/Rakefile",
          "test/README.adoc",
          "test/slices/main/action.rb",
          "test/slices/main/actions/home/show.rb",
          "test/slices/main/repo.rb",
          "test/slices/main/templates/home/show.html.erb",
          "test/slices/main/templates/layouts/app.html.erb",
          "test/slices/main/view.rb",
          "test/slices/main/views/home/show.rb",
          "test/spec/hanami_helper.rb",
          "test/spec/spec_helper.rb",
          "test/spec/support/shared_contexts/temp_dir.rb",
          "test/VERSIONS.adoc"
        ].compact
      end

      it "builds maximum skeleton" do
        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }

        expect(project_files).to contain_exactly(*files)
      end
    end

    context "with maximum optional build" do
      let :options do
        %w[
          --build
          test
          --amazing_print
          --caliber
          --circle_ci
          --citation
          --community
          --conduct
          --console
          --contributions
          --debug
          --funding
          --git
          --git_hub
          --git_hub_ci
          --git-lint
          --guard
          --license
          --rake
          --readme
          --reek
          --refinements
          --rspec
          --setup
          --security
          --simple_cov
          --versions
          --zeitwerk
        ]
      end

      let :files do
        [
          "test/.envrc",
          "test/.circleci/config.yml",
          "test/.git/HEAD",
          "test/.github/FUNDING.yml",
          "test/.github/ISSUE_TEMPLATE.md",
          "test/.github/PULL_REQUEST_TEMPLATE.md",
          "test/.github/workflows/ci.yml",
          "test/.gitignore",
          "test/.reek.yml",
          "test/.rubocop.yml",
          "test/.ruby-version",
          "test/config.ru",
          "test/app/action.rb",
          "test/app/repo.rb",
          "test/app/view.rb",
          "test/bin/console",
          "test/bin/guard",
          "test/bin/hanami",
          "test/bin/rspec",
          "test/bin/rubocop",
          "test/bin/setup",
          "test/CITATION.cff",
          "test/config/app.rb",
          "test/config/providers/persistence.rb",
          "test/config/puma.rb",
          "test/config/routes.rb",
          "test/config/settings.rb",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"),
          "test/Guardfile",
          "test/lib/test/types.rb",
          "test/LICENSE.adoc",
          "test/Procfile",
          "test/Procfile.dev",
          "test/Rakefile",
          "test/README.adoc",
          "test/slices/main/action.rb",
          "test/slices/main/actions/home/show.rb",
          "test/slices/main/repo.rb",
          "test/slices/main/templates/home/show.html.erb",
          "test/slices/main/templates/layouts/app.html.erb",
          "test/slices/main/view.rb",
          "test/slices/main/views/home/show.rb",
          "test/spec/hanami_helper.rb",
          "test/spec/spec_helper.rb",
          "test/spec/support/shared_contexts/temp_dir.rb",
          "test/VERSIONS.adoc"
        ].compact
      end

      it "builds maximum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to contain_exactly(*files)
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
