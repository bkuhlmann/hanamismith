# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton stylesheet.
    class Stylesheet < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        path = "%project_name%/slices/home/assets/css/app.css.erb"
        builder.call(configuration.merge(template_path: path)).render
        configuration
      end
    end
  end
end
