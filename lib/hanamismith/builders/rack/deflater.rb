# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Rack
      # Builds project skeleton.
      class Deflater
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          builder.call(configuration.merge(template_path: "%project_name%/config/app.rb.erb"))
                 .insert_after(/Rack::Attack/, "    config.middleware.use Rack::Deflater\n")

          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
