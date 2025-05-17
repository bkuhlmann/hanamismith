# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Environments::All do
  using Refinements::Struct

  subject(:builder) { described_class.new generator:, settings:, logger: }

  include_context "with application dependencies"

  let(:generator) { class_double SecureRandom, hex: "51de75280317d90c0fe901757ecd68" }

  describe "#call" do
    it "builds file" do
      builder.call

      expect(temp_dir.join("test/.env").read).to eq(<<~CONTENT)
        PG_DATABASE=test
        PG_PASSWORD=51de75280317d90c0fe901757ecd68
        PG_USER=test
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
