# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Refinement do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "builds implementation" do
      expect(temp_dir.join("test/lib/test/refinements/actions/response.rb").read).to eq(<<~CONTENT)
        module Test
          module Refinements
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
      path = "test/spec/lib/test/refinements/actions/response_spec.rb"
      expect(temp_dir.join(path).read).to eq(<<~CONTENT)
        require "hanami_helper"

        RSpec.describe Test::Refinements::Actions::Response do
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
  end
end
