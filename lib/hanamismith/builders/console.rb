# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton console for object inspection and exploration.
    class Console < Rubysmith::Builders::Console
      using Refinements::Structs

      def call
        return configuration unless configuration.build_console

        super
        builder.call(configuration.merge(template_path: "%project_name%/bin/console.erb"))
               .replace(/require_relative.+/, %(require "hanami/prepare"))

        configuration
      end
    end
  end
end
