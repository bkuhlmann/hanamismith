# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Configuration::Content do
  subject(:content) { described_class.new }

  describe "#initialize" do
    it "answers default hash" do
      expect(content).to have_attributes(
        action_config: nil,
        action_help: nil,
        action_version: nil
      )
    end
  end
end
