# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Node do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds configuration" do
      builder.call

      expect(temp_dir.join("test/package.json").read).to eq(<<~CONTENT)
        {
          "name": "test",
          "description": "",
          "version": "0.0.0",
          "author": "Jill Smith",
          "license": "Hippocratic-2.1",
          "private": true,
          "type": "module",
          "keywords": ["ruby", "hanami"],
          "dependencies": {
            "hanami-assets": "^2.2.0"
          }
        }
      CONTENT
    end

    it "builds node version" do
      builder.call
      expect(temp_dir.join("test/.node-version").read).to match(/\d+\.\d+\.\d+/)
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
