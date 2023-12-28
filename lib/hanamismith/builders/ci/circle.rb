# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module CI
      # Builds project skeleton Circle CI configuration.
      class Circle
        using Refinements::Struct

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_circle_ci

          path = "%project_name%/.circleci/config.yml.erb"
          builder.call(configuration.merge(template_path: path)).render.replace(/\n\n\Z/, "\n")
          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
