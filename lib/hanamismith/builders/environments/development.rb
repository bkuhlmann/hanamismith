# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Environments
      # Builds development environment skeleton.
      class Development
        using Refinements::Struct

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          builder.call(configuration.merge(template_path: "%project_name%/env.development.erb"))
                 .render
                 .rename(".env.development")

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
