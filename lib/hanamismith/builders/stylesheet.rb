# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton stylesheet.
    class Stylesheet < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        path = "%project_name%/app/assets/css/app.css.erb"
        builder.call(settings.merge(template_path: path)).render
        true
      end
    end
  end
end
