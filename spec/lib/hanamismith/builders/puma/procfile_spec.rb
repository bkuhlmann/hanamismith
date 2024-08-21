# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Puma::Procfile do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    before do
      settings.merge! settings.minimize
      builder.call
    end

    it "builds production file" do
      expect(temp_dir.join("test/Procfile").read).to eq(
        "web: bundle exec puma --config ./config/puma.rb\n" \
        "assets: bundle exec hanami assets compile\n"
      )
    end

    it "builds development file" do
      expect(temp_dir.join("test/Procfile.dev").read).to eq(
        %(web: rerun --dir app,config,lib,slices --pattern="**/*.{erb,rb}" ) \
        "-- bundle exec puma --config ./config/puma.rb\n" \
        "assets: bundle exec hanami assets watch\n"
      )
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
