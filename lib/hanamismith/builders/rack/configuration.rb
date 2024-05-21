# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Rack
      # Builds project skeleton.
      class Configuration < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          builder.call(configuration.merge(template_path: "%project_name%/config.ru.erb")).render
          configuration
        end
      end
    end
  end
end
