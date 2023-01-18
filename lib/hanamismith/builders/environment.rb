# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project environment skeleton.
    class Environment
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        builder.call(configuration.merge(template_path: "%project_name%/envrc.erb"))
               .render
               .rename(".envrc")

        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
