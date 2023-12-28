# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton for Node.
    class Node
      using Refinements::Struct

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        path = "%project_name%/package.json.erb"
        builder.call(configuration.merge(template_path: path)).render
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
