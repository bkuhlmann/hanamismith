# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Setup do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:build_path) { temp_dir.join "test/bin/setup" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_setup: true }

      it "appends script" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env bash

          set -o nounset
          set -o errexit
          set -o pipefail
          IFS=$'\\n\\t'

          bundle install
          npm install

          bin/hanami db create
          bin/hanami db migrate

          HANAMI_ENV=test bin/hanami db create
          HANAMI_ENV=test bin/hanami db migrate
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build setup script" do
        builder.call
        expect(build_path.exist?).to be(false)
      end
    end
  end
end
