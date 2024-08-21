# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Docker
      # Builds Dockerfile configuration.
      class File < Rubysmith::Builders::Docker::File
        using Refinements::Struct

        def call
          return false unless settings.build_docker

          super
          builder.call(settings.merge(template_path: "%project_name%/Dockerfile.erb"))
                 .render
                 .insert_after(/RACK_ENV/, "ENV HANAMI_ENV=production\n")
          true
        end
      end
    end
  end
end
