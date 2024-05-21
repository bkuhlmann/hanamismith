# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module CI
      # Builds project skeleton GitHub CI configuration.
      class GitHub < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_git_hub_ci

          path = "%project_name%/.github/workflows/ci.yml.erb"
          builder.call(configuration.merge(template_path: path)).render.replace(/\n\n\Z/, "\n")
          configuration
        end
      end
    end
  end
end
