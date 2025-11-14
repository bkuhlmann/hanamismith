# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Binstub do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/bin/hanami" }

    it "builds file" do
      builder.call

      expect(path.read).to eq(<<~CONTENT)
        #! /usr/bin/env ruby

        require "bundler/setup"

        load Gem.bin_path "hanami-cli", "hanami"
      CONTENT
    end

    it "updates file permissions" do
      builder.call
      expect(path.stat.mode).to eq(33261)
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
