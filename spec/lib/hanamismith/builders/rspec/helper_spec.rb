# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Helper do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      it "adds helper" do
        expect(temp_dir.join("test/spec/spec_helper.rb").read).to eq(<<~CONTENT)
          require "bundler/setup"
          Bundler.require :tools


          Dir[File.join(__dir__, "support", "shared_contexts", "**/*.rb")].each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
            config.order = :random
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

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't add helper" do
        expect(temp_dir.join("test/spec/spec_helper.rb").exist?).to be(false)
      end
    end
  end
end
