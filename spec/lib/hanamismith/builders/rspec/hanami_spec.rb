# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::RSpec::Hanami do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      it "adds helper" do
        expect(temp_dir.join("test/spec/hanami_helper.rb").read).to eq(<<~CONTENT)
          require "capybara/cuprite"
          require "capybara/rspec"
          require "rack/test"
          require "spec_helper"

          ENV["HANAMI_ENV"] = "test"
          require "hanami/prepare"

          Capybara.server = :puma, {Silent: true}
          Capybara.javascript_driver = :cuprite
          Capybara.register_driver :cuprite do |app|
            Capybara::Cuprite::Driver.new app, window_size: [1200, 800]
          end

          RSpec.shared_context "with Hanami application" do
            let(:app) { Hanami.app }
          end

          RSpec.configure do |config|
            config.include Rack::Test::Methods, type: :request
            config.include_context "with Hanami application", type: :request
          end
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't add helper" do
        expect(temp_dir.join("test/spec/hanami_helper.rb").exist?).to be(false)
      end
    end
  end
end
