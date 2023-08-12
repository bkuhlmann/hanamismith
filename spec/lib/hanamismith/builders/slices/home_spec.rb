# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Slices::Home do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "adds action" do
      expect(temp_dir.join("test/slices/home/action.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Home
          # The home action.
          class Action < Test::Action
          end
        end
      CONTENT
    end

    it "adds repository" do
      expect(temp_dir.join("test/slices/home/repository.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Home
          # The home repository.
          class Repository < Test::Repository
          end
        end
      CONTENT
    end

    it "adds view" do
      expect(temp_dir.join("test/slices/home/view.rb").read).to eq(<<~CONTENT)
        # auto_register: false

        module Home
          # The home view.
          class View < Test::View
          end
        end
      CONTENT
    end

    it "adds layout template" do
      template = temp_dir.join("test/slices/home/templates/layouts/app.html.erb").read
      proof = SPEC_ROOT.join("support/fixtures/proofs/layout.html").read

      expect(template).to eq(proof)
    end

    it "adds show template" do
      template = temp_dir.join("test/slices/home/templates/show.html.erb").read
      proof = SPEC_ROOT.join("support/fixtures/proofs/show.html").read

      expect(template).to eq(proof)
    end

    it "adds show view" do
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

    it "adds show action" do
      expect(temp_dir.join("test/slices/home/actions/show.rb").read).to eq(<<~CONTENT)
        module Home
          module Actions
            # Processes show action.
            class Show < Home::Action
              def handle(*, response) = response.render view
            end
          end
        end
      CONTENT
    end
  end
end
