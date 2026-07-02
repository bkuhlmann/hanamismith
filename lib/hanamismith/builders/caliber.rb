# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton with Caliber style support.
    class Caliber < Rubysmith::Builders::Caliber
      using Refinements::Struct

      def call
        return false unless settings.build_caliber

        super
        with_template.append "\nplugins: rubocop-sequel\n\n"
        add_configuration
        true
      end

      private

      def add_configuration
        with_template.append <<~CONTENT
          Metrics/MethodLength:
            Exclude:
              - config/initializers/universal_logger_patch.rb
          RSpec/SpecFilePathFormat:
            CustomTransform:
              #{settings.project_namespaced_class}: ""
        CONTENT
      end

      def with_template
        path = "%project_name%/.config/rubocop/config.yml.erb"
        builder.call settings.with(template_path: path)
      end
    end
  end
end
