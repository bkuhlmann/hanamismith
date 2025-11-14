# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rake::Configuration do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    context "with maximum flags" do
      before { settings.with! settings.maximize }

      it "updates file" do
        builder.call

        expect(temp_dir.join("test/Rakefile").read).to eq(<<~CONTENT)
          require "bundler/setup"
          require "hanami/rake_tasks"
            require "git/lint/rake/register"
            require "reek/rake/task"
            require "rspec/core/rake_task"
            require "rubocop/rake_task"

            Git::Lint::Rake::Register.call
            Reek::Rake::Task.new
            RSpec::Core::RakeTask.new { |task| task.verbose = false }
            RuboCop::RakeTask.new

          Rake.add_rakelib "lib/tasks"

          desc "Run code quality checks"
          task quality: %i[git_lint reek rubocop]

          task default: %i[quality spec]
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "with minimum flags" do
      before { settings.with! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.join("test/Rakefile").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
