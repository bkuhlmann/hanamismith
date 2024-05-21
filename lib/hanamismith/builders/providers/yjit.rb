# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Providers
      # Builds project skeleton for YJIT provider.
      class YJIT < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          path = "%project_name%/config/providers/yjit.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
          configuration
        end
      end
    end
  end
end
