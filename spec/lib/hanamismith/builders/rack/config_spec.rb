# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rack::Config do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "doesn't build Rakefile" do
      expect(temp_dir.join("test/config.ru").read).to eq(<<~CONTENT)
        require "hanami/boot"
        Bundler.require :tools if Hanami.env? :development

        app = Rack::Builder.app { run Hanami.app }

        run app
      CONTENT
    end
  end
end
