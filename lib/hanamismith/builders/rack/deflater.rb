# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Rack
      # Builds project skeleton.
      class Deflater < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          builder.call(configuration.merge(template_path: "%project_name%/config/app.rb.erb"))
                 .insert_after(/Rack::Attack/, "    config.middleware.use Rack::Deflater\n")

          configuration
        end
      end
    end
  end
end
