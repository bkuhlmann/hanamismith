# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Slices
      # Builds health slice skeleton.
      class Health
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          add_action
          configuration
        end

        private

        attr_reader :configuration, :builder

        def add_action
          %w[
            %project_name%/slices/health/actions/show.rb.erb
            %project_name%/spec/slices/health/actions/show_spec.rb.erb
          ].each do |path|
            builder.call(configuration.merge(template_path: path)).render
          end
        end
      end
    end
  end
end
