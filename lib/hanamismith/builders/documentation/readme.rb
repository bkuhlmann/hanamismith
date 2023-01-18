# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme < Rubysmith::Builders::Documentation::Readme
        using Refinements::Structs

        def call
          return configuration unless configuration.build_readme

          super
          builder.call(configuration.merge(template_path: "%project_name%/README.#{kind}.erb"))
                 .replace("Rubysmith", "Hanamismith")
                 .replace("rubysmith", "hanamismith")

          configuration
        end

        private

        attr_reader :configuration, :builder

        def kind = configuration.documentation_format
      end
    end
  end
end
