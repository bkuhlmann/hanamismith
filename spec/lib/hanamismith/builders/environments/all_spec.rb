# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Environments::All do
  using Refinements::Struct

  subject(:builder) { described_class.new generator:, settings:, logger: }

  include_context "with application dependencies"

  let(:generator) { class_double SecureRandom }

  describe "#call" do
    before { allow(generator).to receive(:hex).and_return("abc", "def") }

    it "builds file" do
      builder.call

      expect(temp_dir.join("test/.env").read).to eq(<<~CONTENT)
        APP_SECRET=abc

        PG_DATABASE=test
        PG_PASSWORD=def
        PG_PORT=5432
        PG_USER=test
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
