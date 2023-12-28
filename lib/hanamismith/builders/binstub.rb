# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton binstub.
    class Binstub
      using Refinements::Struct

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        builder.call(configuration.merge(template_path: "%project_name%/bin/hanami.erb"))
               .render
               .permit 0o755

        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
