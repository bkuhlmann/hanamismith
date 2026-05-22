# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Providers
      # Builds project skeleton for database provider.
      class Database < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          path = "%project_name%/config/providers/db.rb.erb"
          builder.call(settings.with(template_path: path)).render
          true
        end
      end
    end
  end
end
