# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::PWA do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds file" do
      builder.call

      expect(temp_dir.join("test/app/assets/pwa/manifest.webmanifest").read).to eq(<<~CONTENT)
        {
          "name": "Test",
          "short_name": "Test",
          "description": "A Hanamismith skeleton application.",
          "icons": [
            {
              "src": "https://alchemists.io/images/projects/hanamismith/icons/small.png",
              "type": "image/png",
              "sizes": "192x192"
            },
            {
              "src": "https://alchemists.io/images/projects/hanamismith/icons/large.png",
              "type": "image/png",
              "sizes": "512x512"
            }
          ],
          "display": "standalone",
          "start_url": "/",
          "scope": "/",
          "theme_color": "#000000"
        }
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
