# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton foundation.
    class Refinement
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        %w[
          %project_name%/lib/%project_path%/refinements/actions/response.rb.erb
          %project_name%/spec/lib/%project_path%/refinements/actions/response_spec.rb.erb
        ].each do |path|
          builder.call(configuration.merge(template_path: path)).render
        end

        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
