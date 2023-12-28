# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Git::Ignore do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    context "with enabled" do
      let(:test_configuration) { configuration.minimize.merge build_git: true }

      it "builds Git ignore" do
        builder.call

        expect(temp_dir.join("test/.gitignore").read).to eq(<<~CONTENT)
          .bundle
          node_modules
          public
          tmp
        CONTENT
      end
    end

    context "with disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build file" do
        builder.call
        expect(temp_dir.join("test/.gitignore").exist?).to be(false)
      end
    end
  end
end
