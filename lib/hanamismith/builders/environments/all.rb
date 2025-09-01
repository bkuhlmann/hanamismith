# frozen_string_literal: true

require "refinements/struct"
require "securerandom"

module Hanamismith
  module Builders
    module Environments
      # Builds test environment skeleton.
      class All < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def initialize(generator: SecureRandom, **)
          @generator = generator
          super(**)
        end

        def call
          builder.call(settings.with(template_path: "%project_name%/env.erb"))
                 .render
                 .replace("<password>", generator.hex(15))
                 .rename(".env")

          true
        end

        private

        attr_reader :generator
      end
    end
  end
end
