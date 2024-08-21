# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Slices::Home do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  describe "#call" do
    before { builder.call }

    it "builds configuration" do
      expect(temp_dir.join("test/config/slices/home.rb").read).to eq(<<~CONTENT)
        module Home
          # The home slice configuration.
          class Slice < Hanami::Slice
            import keys: ["assets"], from: Hanami.app.container, as: :app
          end
        end
      CONTENT
    end

    it "builds action" do
      expect(temp_dir.join("test/slices/home/action.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Home
          # The home action.
          class Action < Test::Action
          end
        end
      CONTENT
    end

    it "builds repository" do
      expect(temp_dir.join("test/slices/home/repository.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Home
          # The home repository.
          class Repository < Test::Repository
          end
        end
      CONTENT
    end

    it "builds view" do
      expect(temp_dir.join("test/slices/home/view.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Home
          # The home view.
          class View < Test::View
          end
        end
      CONTENT
    end

    it "builds context" do
      expect(temp_dir.join("test/slices/home/views/context.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Home
          module Views
            # Defines custom context.
            class Context < Hanami::View::Context
              include Deps[app_assets: "app.assets"]
            end
          end
        end
      CONTENT
    end

    it "builds layout template" do
      template = temp_dir.join("test/slices/home/templates/layouts/app.html.erb").read
      proof = SPEC_ROOT.join("support/fixtures/views/home-layout.html").read

      expect(template).to eq(proof)
    end

    it "builds show template" do
      template = temp_dir.join("test/slices/home/templates/show.html.erb").read
      proof = SPEC_ROOT.join("support/fixtures/views/show.html").read

      expect(template).to eq(proof)
    end

    it "builds show view" do
      expect(temp_dir.join("test/slices/home/views/show.rb").read).to eq(<<~CONTENT)
        module Home
          module Views
            # Renders show view.
            class Show < Home::View
              expose :ruby_version, default: RUBY_VERSION
              expose :hanami_version, default: Hanami::VERSION
            end
          end
        end
      CONTENT
    end

    it "builds show action" do
      expect(temp_dir.join("test/slices/home/actions/show.rb").read).to eq(<<~CONTENT)
        module Home
          module Actions
            # Processes show action.
            class Show < Home::Action
            end
          end
        end
      CONTENT
    end

    it "builds feature spec" do
      expect(temp_dir.join("test/spec/features/home_spec.rb").read).to eq(<<~CONTENT)
        RSpec.describe "Home", :web do
          it "renders home page" do
            visit "/"
            expect(page).to have_content("Test")
          end
        end
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
