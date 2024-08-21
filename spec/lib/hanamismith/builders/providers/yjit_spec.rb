# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Providers::YJIT do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds file" do
      builder.call

      expect(temp_dir.join("test/config/providers/yjit.rb").read).to eq(<<~CONTENT)
        Hanami.app.register_provider :yjit do
          start { RubyVM::YJIT.enable }
        end
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
