# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Refinement do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application"

  describe "#call" do
    it "builds implementation" do
      builder.call

      expect(temp_dir.join("test/lib/test/refines/actions/response.rb").read).to eq(<<~CONTENT)
        module Test
          module Refines
            module Actions
              # Modifies and enhances default Hanami action response behavior.
              module Response
                refine Hanami::Action::Response do
                  def with body:, status:
                    @body = [body]
                    @status = status
                    self
                  end
                end
              end
            end
          end
        end
      CONTENT
    end

    it "builds specification" do
      path = "test/spec/lib/test/refines/actions/response_spec.rb"
      builder.call

      expect(temp_dir.join(path).read).to eq(<<~CONTENT)
        require "hanami_helper"

        RSpec.describe Test::Refines::Actions::Response do
          using described_class

          subject(:response) { Hanami::Action::Response.new request:, config: {} }

          let :request do
            Rack::MockRequest.env_for("/").then { |env| Hanami::Action::Request.new env:, params: {} }
          end

          describe "#with" do
            it "answers response with given body and status" do
              expect(response.with(body: "Danger!", status: 400)).to have_attributes(
                body: ["Danger!"],
                status: 400
              )
            end

            it "answers itself" do
              expect(response.with(body: "Danger!", status: 400)).to be_a(Hanami::Action::Response)
            end
          end
        end
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
