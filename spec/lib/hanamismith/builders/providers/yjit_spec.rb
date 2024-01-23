# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Providers::YJIT do
  using Refinements::Struct

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "adds configuration" do
      expect(temp_dir.join("test/config/providers/yjit.rb").read).to eq(<<~CONTENT)
        Hanami.app.register_provider :yjit do
          start { RubyVM::YJIT.enable }
        end
      CONTENT
    end
  end
end
