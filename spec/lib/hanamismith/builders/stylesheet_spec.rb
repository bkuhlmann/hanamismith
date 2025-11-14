# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Stylesheet do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds settings file" do
      builder.call
      expect(temp_dir.join("test/app/assets/css/settings.css").exist?).to be(true)
    end

    it "builds colors file" do
      builder.call
      expect(temp_dir.join("test/app/assets/css/colors.css").exist?).to be(true)
    end

    it "builds view transitions file" do
      builder.call
      expect(temp_dir.join("test/app/assets/css/view_transitions.css").exist?).to be(true)
    end

    it "builds defaults file" do
      builder.call
      expect(temp_dir.join("test/app/assets/css/defaults.css").exist?).to be(true)
    end

    it "builds layout file" do
      builder.call
      expect(temp_dir.join("test/app/assets/css/layout.css").exist?).to be(true)
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
