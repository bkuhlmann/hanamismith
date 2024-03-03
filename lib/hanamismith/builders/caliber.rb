# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton with Caliber style support.
    class Caliber < Rubysmith::Builders::Caliber
      using Refinements::Struct

      def call
        return configuration unless configuration.build_caliber

        super
        path = "%project_name%/.config/rubocop/config.yml.erb"
        builder.call(configuration.merge(template_path: path))
               .append("\nrequire: rubocop-sequel\n")

        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
