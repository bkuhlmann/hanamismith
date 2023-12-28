# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Slices::Health do
  using Refinements::Struct

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "adds action" do
      expect(temp_dir.join("test/slices/health/actions/show.rb").read).to eq(<<~CONTENT)
        module Health
          module Actions
            # The show action.
            class Show < Test::Action
              using Test::Refines::Actions::Response

              handle_exception Exception => :down

              def handle(*, response) = response.with body: body(:green), status: 200

              private

              def down(*, response, _exception) = response.with body: body(:red), status: 503

              def body(color) = %(<html><body style="background-color: \#{color}"></body></html>)
            end
          end
        end
      CONTENT
    end

    it "adds action spec" do
      expect(temp_dir.join("test/spec/slices/health/actions/show_spec.rb").read).to eq(<<~CONTENT)
        require "hanami_helper"

        RSpec.describe Health::Actions::Show do
          subject(:action) { described_class.new }

          describe "#call" do
            it "answers 200 OK status with green background" do
              expect(action.call({})).to have_attributes(
                body: [%(<html><body style="background-color: green"></body></html>)],
                status: 200
              )
            end
          end
        end
      CONTENT
    end
  end
end
