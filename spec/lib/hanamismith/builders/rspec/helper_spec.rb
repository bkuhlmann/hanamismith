# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Helper do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/spec/spec_helper.rb" }

    context "when enabled" do
      before { settings.with! settings.minimize.with build_rspec: true }

      it "builds file" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          Bundler.require :tools


          SPEC_ROOT = Pathname(__dir__).realpath.freeze

          Dir[File.join(SPEC_ROOT, "support", "shared_contexts", "**/*.rb")].each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
            config.order = :random
            config.pending_failure_output = :no_backtrace
            config.shared_context_metadata_behavior = :apply_to_host_groups
            config.warnings = true

            config.expect_with :rspec do |expectations|
              expectations.syntax = :expect
              expectations.include_chain_clauses_in_custom_matcher_descriptions = true
            end

            config.mock_with :rspec do |mocks|
              mocks.verify_doubled_constant_names = true
              mocks.verify_partial_doubles = true
            end


            Kernel.srand config.seed
          end
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with SimpleCov only" do
      before { settings.with! settings.minimize.with build_rspec: true, build_simple_cov: true }

      let :proof do
        <<~BODY
          require "simplecov"

          if ENV["COVERAGE"] == "no"
            puts "SimpleCov skipped due to being disabled."
          else
            SimpleCov.start do
              add_filter %r(^/spec/)
              enable_coverage :branch
              minimum_coverage_by_file line: 95, branch: 95
            end
          end

          Bundler.require :tools


          SPEC_ROOT = Pathname(__dir__).realpath.freeze

          Dir[File.join(SPEC_ROOT, "support", "shared_contexts", "**/*.rb")].each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
            config.order = :random
            config.pending_failure_output = :no_backtrace
            config.shared_context_metadata_behavior = :apply_to_host_groups
            config.warnings = true

            config.expect_with :rspec do |expectations|
              expectations.syntax = :expect
              expectations.include_chain_clauses_in_custom_matcher_descriptions = true
            end

            config.mock_with :rspec do |mocks|
              mocks.verify_doubled_constant_names = true
              mocks.verify_partial_doubles = true
            end


            Kernel.srand config.seed
          end
        BODY
      end

      it "builds file" do
        builder.call
        expect(path.read).to eq(proof)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.join("test/spec/spec_helper.rb").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
