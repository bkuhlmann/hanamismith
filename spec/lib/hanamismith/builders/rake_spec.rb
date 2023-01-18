# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rake do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with minimum flags" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build Rakefile" do
        expect(temp_dir.join("test/Rakefile").exist?).to be(false)
      end
    end

    context "with maximum flags" do
      let(:test_configuration) { configuration.maximize }

      it "updates Rakefile" do
        result = temp_dir.join("test/Rakefile").read.start_with? <<~CONTENT
          require "bundler/setup"
          require "hanami/rake_tasks"
        CONTENT

        expect(result).to be(true)
      end
    end
  end
end
