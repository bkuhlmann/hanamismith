# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton with Caliber style support.
    class Caliber < Rubysmith::Builders::Caliber
      using Refinements::Structs

      def call
        return configuration unless configuration.build_caliber

        super
        builder.call(configuration.merge(template_path: "%project_name%/.rubocop.yml.erb"))
               .append("\nrequire: rubocop-sequel\n")

        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
