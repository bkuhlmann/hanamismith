# frozen_string_literal: true

require "refinements/struct"
require "securerandom"

module Hanamismith
  module Builders
    # Builds project skeleton Circle CI configuration.
    class CircleCI < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def initialize(generator: SecureRandom, **)
        @generator = generator
        super(**)
      end

      def call
        return false unless settings.build_circle_ci

        path = "%project_name%/.circleci/config.yml.erb"

        builder.call(settings.with(template_path: path))
               .render
               .replace("<app_secret>", generator.hex(30))
               .replace(/\n\n\Z/, "\n")

        true
      end

      private

      attr_reader :generator
    end
  end
end
