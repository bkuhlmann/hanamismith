# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton stylesheet.
    class Stylesheet < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        %w[
          %project_name%/app/assets/css/settings.css.erb
          %project_name%/app/assets/css/colors.css.erb
          %project_name%/app/assets/css/view_transitions.css.erb
          %project_name%/app/assets/css/defaults.css.erb
          %project_name%/app/assets/css/layout.css.erb
        ].each do |path|
          builder.call(settings.with(template_path: path)).render
        end

        true
      end
    end
  end
end
