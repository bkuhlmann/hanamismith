# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Layout do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    before { builder.call }

    it "builds layout template" do
      template = temp_dir.join("test/app/templates/layouts/app.html.erb").read
      proof = SPEC_ROOT.join("support/fixtures/views/app-layout.html").read

      expect(template).to eq(proof)
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
