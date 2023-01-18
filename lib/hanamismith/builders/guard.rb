# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton Guard support for a red, green, refactor loop.
    class Guard < Rubysmith::Builders::Guard
      using Refinements::Structs

      def call
        return configuration unless configuration.build_guard

        super
        builder.call(configuration.merge(template_path: "%project_name%/Guardfile.erb")).render
        configuration
      end
    end
  end
end
