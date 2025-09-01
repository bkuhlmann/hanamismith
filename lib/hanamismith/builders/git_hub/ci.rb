# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module GitHub
      # Builds project skeleton GitHub CI configuration.
      class CI < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_git_hub_ci

          path = "%project_name%/.github/workflows/ci.yml.erb"
          builder.call(settings.with(template_path: path)).render.replace(/\n\n\Z/, "\n")
          true
        end
      end
    end
  end
end
