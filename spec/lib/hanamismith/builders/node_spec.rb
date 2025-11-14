# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Node do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application"

  describe "#call" do
    let(:version_path) { temp_dir.join "test/.node-version" }

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
          "keywords": ["hanami", "htmx", "ruby"],
          "dependencies": {
            "hanami-assets": "^2.3.0",
            "htmx.org": "^2.0.8"
          }
        }
      CONTENT
    end

    it "builds node version" do
      builder.call
      expect(version_path.read).to match(/\d+\.\d+\.\d+/)
    end

    it "logs error when Node version can't be obtained" do
      status = instance_double Process::Status, success?: false
      executor = class_double Open3, capture3: ["stdout", "stderr", status]
      builder = described_class.new(executor:, settings:, logger:)

      builder.call

      expect(logger.reread).to match(/🛑.+Unable to obtain version for #{version_path.inspect}.+/)
    end

    it "logs error when Node isn't found" do
      executor = class_double Open3
      allow(executor).to receive(:capture3).and_raise Errno::ENOENT, "Danger!"
      builder = described_class.new(executor:, settings:, logger:)

      builder.call

      expect(logger.reread).to match(/🛑.+Unable to find Node. Is Node installed?.+/)
    end

    it "logs error when executor fails" do
      intermediary = instance_double Object
      executor = class_double Open3, capture3: intermediary
      allow(intermediary).to receive(:then).and_return "Danger!"
      builder = described_class.new(executor:, settings:, logger:)

      builder.call

      expect(logger.reread).to match(
        /🛑.+Shell failure. Is your environment configured properly?.+/
      )
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
