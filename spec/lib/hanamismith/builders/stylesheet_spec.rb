# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Stylesheet do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds stylesheet" do
      expect(temp_dir.join("test/public/stylesheets/site.css").read).to eq(<<~CONTENT)
        :root {
          --site-font-family: Verdana;
        }

        .page {
          align-items: center;
          display: flex;
          flex-direction: column;
          font-family: var(--site-font-family);
          margin: 1rem 5rem;
        }
      CONTENT
    end
  end
end
