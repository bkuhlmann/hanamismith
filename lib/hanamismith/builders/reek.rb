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
        add_duplicate_exclusion
        add_too_many_statements_exclusion
        true
      end

      def add_duplicate_exclusion
        with_template.insert_before(
          /LongParameterList:\n/,
          <<~DETECTORS.gsub(/^/, "  ")
            DuplicateMethodCall:
              exclude:
                - UniversalLoggerPatch#_log_structured
          DETECTORS
        )
      end

      def add_too_many_statements_exclusion
        with_template.insert_after(
          /enabled:\sfalse\n/,
          <<~DETECTORS.gsub(/^/, "  ")
            TooManyStatements:
              exclude:
                - UniversalLoggerPatch#_log_structured
          DETECTORS
        )
      end

      def with_template
        builder.call settings.with(template_path: "%project_name%/.reek.yml.erb")
      end
    end
  end
end
