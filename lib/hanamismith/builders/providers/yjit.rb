# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Providers
      # Builds project skeleton for YJIT provider.
      class YJIT
        using Refinements::Struct

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          path = "%project_name%/config/providers/yjit.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
