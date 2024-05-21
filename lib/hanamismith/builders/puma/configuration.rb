# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Puma
      # Builds project skeleton Puma configuration.
      class Configuration < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          builder.call(configuration.merge(template_path: "%project_name%/config/puma.rb.erb"))
                 .render

          configuration
        end
      end
    end
  end
end
