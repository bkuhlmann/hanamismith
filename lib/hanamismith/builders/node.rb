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
        builder.call(configuration.merge(template_path: "%project_name%/package.json.erb")).render
        builder.call(configuration.merge(template_path: "%project_name%/.node-version.erb")).render
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
