# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Slices::Health do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    it "adds configuration" do
      builder.call

      expect(temp_dir.join("test/config/slices/health.rb").read).to eq(<<~CONTENT)
        module Health
          # The health slice configuration.
          class Slice < Hanami::Slice
            import keys: ["assets"], from: Hanami.app.container, as: :app
          end
        end
      CONTENT
    end

    it "adds action" do
      builder.call

      expect(temp_dir.join("test/slices/health/action.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Health
          # The health action.
          class Action < Test::Action
          end
        end
      CONTENT
    end

    it "adds view" do
      builder.call

      expect(temp_dir.join("test/slices/health/view.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Health
          # The health view.
          class View < Test::View
          end
        end
      CONTENT
    end

    it "adds layout template" do
      builder.call

      template = temp_dir.join("test/slices/health/templates/layouts/app.html.erb").read
      proof = SPEC_ROOT.join("support/fixtures/views/health-layout.html").read

      expect(template).to eq(proof)
    end

    it "adds show template" do
      builder.call

      expect(temp_dir.join("test/slices/health/templates/show.html.erb").read).to eq(<<~CONTENT)
        <% content_for :title, "Health | Test" %>

        <main style="background-color: <%= color %>; height: 100vh;">
        </main>
      CONTENT
    end

    it "adds context" do
      builder.call

      expect(temp_dir.join("test/slices/health/views/context.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Health
          module Views
            # Defines custom context.
            class Context < Hanami::View::Context
              include Deps[app_assets: "app.assets"]
            end
          end
        end
      CONTENT
    end

    it "adds show view" do
      builder.call

      expect(temp_dir.join("test/slices/health/views/show.rb").read).to eq(<<~CONTENT)
        module Health
          module Views
            # Renders show view.
            class Show < Health::View
              expose :color
            end
          end
        end
      CONTENT
    end

    it "adds show action" do
      builder.call

      expect(temp_dir.join("test/slices/health/actions/show.rb").read).to eq(<<~CONTENT)
        module Health
          module Actions
            # The show action.
            class Show < Health::Action
              handle_exception Exception => :down

              def handle(*, response) = response.render view, color: :green

              private

              def down(*, response, _exception) = response.render view, color: :red, status: 503
            end
          end
        end
      CONTENT
    end

    it "adds action spec" do
      builder.call

      expect(temp_dir.join("test/spec/slices/health/actions/show_spec.rb").read).to eq(<<~CONTENT)
        require "hanami_helper"

        RSpec.describe Health::Actions::Show do
          subject(:action) { described_class.new }

          describe "#call" do
            it "answers green background" do
              expect(action.call({}).body.first).to include(
                %(<main style="background-color: green; height: 100vh;">\\n</main>)
              )
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
