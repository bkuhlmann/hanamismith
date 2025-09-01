# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Docker
      # Builds Docker compose configuration.
      class Compose < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_docker

          builder.call(settings.with(template_path: "%project_name%/compose.yml.erb")).render
          true
        end
      end
    end
  end
end
