# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton Reek code quality support.
    class Reek < Rubysmith::Builders::Reek
      using Refinements::Struct

      def call
        return false unless settings.build_reek

        super
        add_detectors
        true
      end

      def add_detectors
        with_template.insert_after(
          /enabled:\sfalse\n/,
          <<~DETECTORS.gsub(/^/, "  ")
            TooManyStatements:
              exclude:
                - RackLoggerPatch#prepare_app_providers
            UtilityFunction:
              exclude:
                - SQLLoggerPatch#log_query
          DETECTORS
        )
      end

      def with_template
        builder.call settings.with(template_path: "%project_name%/.reek.yml.erb")
      end
    end
  end
end
