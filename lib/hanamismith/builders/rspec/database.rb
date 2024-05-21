# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module RSpec
      # Builds project skeleton RSpec application database support.
      class Database < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_rspec

          path = "%project_name%/spec/support/database.rb.erb"
          builder.call(configuration.merge(template_path: path)).render

          configuration
        end
      end
    end
  end
end
