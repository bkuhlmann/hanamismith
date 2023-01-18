# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Puma::Procfile do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:test_configuration) { configuration.minimize }

    before { builder.call }

    it "builds production file" do
      expect(temp_dir.join("test/Procfile").read).to eq(
        "web: bundle exec puma --port $PORT --config ./config/puma.rb\n"
      )
    end

    it "builds development file" do
      expect(temp_dir.join("test/Procfile.dev").read).to eq(
        %(web: rerun --pattern="**/*.{css,erb,js,rb}" ) \
        "-- bundle exec puma --config ./config/puma.rb\n"
      )
    end
  end
end
