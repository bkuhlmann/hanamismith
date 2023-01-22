# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Rack
      # Builds project skeleton with Rack Attack provider.
      class Attack
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          path = "%project_name%/config/providers/rack_attack.rb.erb"
          builder.call(configuration.merge(template_path: path)).render

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
