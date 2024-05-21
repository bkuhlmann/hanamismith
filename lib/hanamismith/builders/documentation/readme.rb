# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme < Rubysmith::Builders::Documentation::Readme
        using Refinements::Struct

        def call
          return configuration unless configuration.build_readme

          super
          builder.call(configuration.merge(template_path: "%project_name%/README.#{kind}.erb"))
                 .replace("Rubysmith", "Hanamismith")
                 .replace("rubysmith", "hanamismith")

          configuration
        end
      end
    end
  end
end
