# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Rack::Attack do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "doesn't build Rakefile" do
      expect(temp_dir.join("test/config/providers/rack_attack.rb").read).to eq(<<~CONTENT)
        Hanami.app.register_provider :rack_attack do
          prepare { require "rack/attack" }

          start do
            Rack::Attack.safelist "allow from localhost" do |request|
              %w[127.0.0.1 ::1].include? request.ip
            end

            Rack::Attack.throttle("requests by IP", limit: 100, period: 60, &:ip)
          end
        end
      CONTENT
    end
  end
end
