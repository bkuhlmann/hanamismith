# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Git::Ignore do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    context "with enabled" do
      before { settings.merge! settings.minimize.merge build_git: true }

      it "builds file" do
        builder.call

        expect(temp_dir.join("test/.gitignore").read).to eq(<<~CONTENT)
          .bundle
          node_modules
          public/assets
          public/assets.json
          tmp
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "with disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.join("test/.gitignore").exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
