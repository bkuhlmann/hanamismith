# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module RSpec
      # Builds project skeleton RSpec helper.
      class Hanami
        using Refinements::Struct

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_rspec

          path = "%project_name%/spec/hanami_helper.rb.erb"
          builder.call(configuration.merge(template_path: path)).render

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
