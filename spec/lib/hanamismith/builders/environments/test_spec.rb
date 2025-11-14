# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Environments::Test do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds file" do
      builder.call

      expect(temp_dir.join("test/.env.test").read).to eq(<<~CONTENT)
        DATABASE_URL=postgres://localhost/test_test
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
