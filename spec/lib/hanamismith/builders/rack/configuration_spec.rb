# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rack::Configuration do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds file" do
      builder.call

      expect(temp_dir.join("test/config.ru").read).to eq(<<~CONTENT)
        require "hanami/boot"
        Bundler.require :tools if Hanami.env? :development

        app = Rack::Builder.app { run Hanami.app }

        run app
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
