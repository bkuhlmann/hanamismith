# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Environments
      # Builds test environment skeleton.
      class Test < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          builder.call(settings.with(template_path: "%project_name%/env.test.erb"))
                 .render
                 .rename(".env.test")

          true
        end
      end
    end
  end
end
