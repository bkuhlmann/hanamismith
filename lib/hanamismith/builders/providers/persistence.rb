# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Providers
      # Builds project skeleton for persistence provider.
      class Persistence < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          path = "%project_name%/config/providers/persistence.rb.erb"
          builder.call(settings.merge(template_path: path)).render
          true
        end
      end
    end
  end
end
