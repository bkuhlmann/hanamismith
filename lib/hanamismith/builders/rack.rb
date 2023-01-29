# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton Rack support.
    class Rack
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        builder.call(configuration.merge(template_path: "%project_name%/config.ru.erb")).render
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
