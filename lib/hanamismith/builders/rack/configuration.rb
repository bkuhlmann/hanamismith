# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Rack
      # Builds project skeleton.
      class Configuration < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          builder.call(settings.merge(template_path: "%project_name%/config.ru.erb")).render
          true
        end
      end
    end
  end
end
