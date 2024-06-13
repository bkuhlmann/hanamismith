# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton Guard support for a red, green, refactor loop.
    class Guard < Rubysmith::Builders::Guard
      using Refinements::Struct

      def call
        return false unless settings.build_guard

        super
        builder.call(settings.merge(template_path: "%project_name%/Guardfile.erb")).render
        true
      end
    end
  end
end
