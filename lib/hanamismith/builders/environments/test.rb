# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Environments
      # Builds test environment skeleton.
      class Test
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          builder.call(configuration.merge(template_path: "%project_name%/env.test.erb"))
                 .render
                 .rename(".env.test")

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
