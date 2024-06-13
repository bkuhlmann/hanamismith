# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton SVG icon.
    class Icon < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        path = "%project_name%/app/assets/images/icon.svg.erb"
        builder.call(settings.merge(template_path: path)).render
        true
      end
    end
  end
end
