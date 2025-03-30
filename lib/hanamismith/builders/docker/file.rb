# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Docker
      # Builds Dockerfile configuration.
      class File < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_docker

          builder.call(settings.merge(template_path: "%project_name%/Dockerfile.erb")).render
          true
        end
      end
    end
  end
end
