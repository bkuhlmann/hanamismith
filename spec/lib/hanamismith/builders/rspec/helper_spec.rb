# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Helper do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:spec_helper_path) { temp_dir.join "test/spec/spec_helper.rb" }

    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      it "adds helper" do
        expect(spec_helper_path.read).to eq(<<~CONTENT)
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
          end
        CONTENT
      end
    end

    context "when enabled with SimpleCov only" do
      let :test_configuration do
        configuration.minimize.merge build_rspec: true, build_simple_cov: true
      end

      let :proof do
        <<~BODY
          require "simplecov"

          unless ENV["NO_COVERAGE"]
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
          end
        BODY
      end

      it "builds spec helper" do
        expect(spec_helper_path.read).to eq(proof)
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't add helper" do
        expect(temp_dir.join("test/spec/spec_helper.rb").exist?).to be(false)
      end
    end
  end
end
