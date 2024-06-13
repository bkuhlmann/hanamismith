# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton Circle CI configuration.
    class CircleCI < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        return false unless settings.build_circle_ci

        path = "%project_name%/.circleci/config.yml.erb"
        builder.call(settings.merge(template_path: path)).render.replace(/\n\n\Z/, "\n")
        true
      end
    end
  end
end
