# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Puma
      # Builds project skeleton Puma Procfile for production and development environments.
      class Procfile < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          builder.call(settings.with(template_path: "%project_name%/Procfile.erb")).render
          builder.call(settings.with(template_path: "%project_name%/Procfile.dev.erb")).render
          true
        end
      end
    end
  end
end
