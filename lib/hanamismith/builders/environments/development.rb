# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Environments
      # Builds development environment skeleton.
      class Development < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          builder.call(settings.merge(template_path: "%project_name%/env.development.erb"))
                 .render
                 .rename(".env.development")

          true
        end
      end
    end
  end
end
