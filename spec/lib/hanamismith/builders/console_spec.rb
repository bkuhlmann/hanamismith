# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Console do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  let(:build_path) { temp_dir.join "test/bin/console" }

  describe "#call" do
    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_console: true }

      it "builds file" do
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

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(build_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
