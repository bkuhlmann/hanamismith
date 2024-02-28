# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Node do
  using Refinements::Struct

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds stylesheet" do
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
            "hanami-assets": "^2.1.0"
          }
        }
      CONTENT
    end
  end
end
