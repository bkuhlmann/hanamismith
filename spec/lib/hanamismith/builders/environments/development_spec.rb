# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Environments::Development do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds environment configuration" do
      expect(temp_dir.join("test/.env.development").read).to eq(<<~CONTENT)
        DATABASE_URL=postgres://localhost/test_development
      CONTENT
    end
  end
end
