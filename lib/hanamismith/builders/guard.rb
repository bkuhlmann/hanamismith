# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton Guard support for a red, green, refactor loop.
    class Guard < Rubysmith::Builders::Guard
      using Refinements::Struct

      def call
        return configuration unless configuration.build_guard

        super
        builder.call(configuration.merge(template_path: "%project_name%/Guardfile.erb")).render
        configuration
      end
    end
  end
end
