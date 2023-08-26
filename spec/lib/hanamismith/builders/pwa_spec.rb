# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::PWA do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds stylesheet" do
      expect(temp_dir.join("test/public/manifest.webmanifest").read).to eq(<<~CONTENT)
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
          "theme_color": "#E39184"
        }
      CONTENT
    end
  end
end
