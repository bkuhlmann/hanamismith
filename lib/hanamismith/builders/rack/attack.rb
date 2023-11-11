# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Rack
      # Builds project skeleton.
      class Attack
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          add_configuration
          add_middleware
          configuration
        end

        private

        attr_reader :configuration, :builder

        def add_configuration
          template_path = "%project_name%/config/initializers/rack_attack.rb.erb"
          builder.call(configuration.merge(template_path:)).render
        end

        def add_middleware
          builder.call(configuration.merge(template_path: "%project_name%/config/app.rb.erb"))
                 .insert_after(/require/, %(\nrequire_relative "initializers/rack_attack"\n))
                 .insert_before(/environment/, "    config.middleware.use Rack::Attack\n\n")
        end
      end
    end
  end
end
