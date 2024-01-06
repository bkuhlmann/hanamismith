# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Console do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:build_path) { temp_dir.join "test/bin/console" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_console: true }

      it "builds console script" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"
          Bundler.require :tools

          require "hanami/prepare"
          require "irb"

          unless Hanami.env? :development, :test
            ENV["IRB_USE_AUTOCOMPLETE"] ||= "false"
            puts "IRB autocomplete disabled."
          end

          IRB.start __FILE__
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build console script" do
        builder.call
        expect(build_path.exist?).to be(false)
      end
    end
  end
end
