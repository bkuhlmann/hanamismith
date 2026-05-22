# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Providers::HTMX do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds file" do
      builder.call

      expect(temp_dir.join("test/config/providers/htmx.rb").read).to eq(<<~CONTENT)
        Hanami.app.register_provider :htmx do
          prepare { require "htmx" }

          start do
            toggler = lambda do |request, default = "app"|
              HTMX.request?(request.env, :request, "true") ? false : default
            end

            register :htmx, HTMX
            register :htmx_defaults, {"allowScriptTags" => false, "defaultSwapStyle" => "outerHTML"}.freeze
            register :htmx_layout, toggler
          end
        end
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
