# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton javascript.
    class Javascript
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        path = "%project_name%/slices/home/assets/js/app.js.erb"
        builder.call(configuration.merge(template_path: path)).render
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
