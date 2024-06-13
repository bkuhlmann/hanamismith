# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Rack
      # Builds project skeleton.
      class Attack < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          add_configuration
          add_middleware
          true
        end

        private

        def add_configuration
          template_path = "%project_name%/config/initializers/rack_attack.rb.erb"
          builder.call(settings.merge(template_path:)).render
        end

        def add_middleware
          builder.call(settings.merge(template_path: "%project_name%/config/app.rb.erb"))
                 .insert_after(/require/, %(\nrequire_relative "initializers/rack_attack"\n))
                 .insert_before(/environment/, "    config.middleware.use Rack::Attack\n\n")
        end
      end
    end
  end
end
