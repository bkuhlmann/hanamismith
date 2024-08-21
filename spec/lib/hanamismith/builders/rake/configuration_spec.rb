# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rake::Configuration do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    context "with maximum flags" do
      before { settings.merge! settings.maximize }

      it "updates file" do
        builder.call

        result = temp_dir.join("test/Rakefile").read.start_with? <<~CONTENT
          require "bundler/setup"
          require "hanami/rake_tasks"
        CONTENT

        expect(result).to be(true)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "with minimum flags" do
      before { settings.merge! settings.minimize }

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
