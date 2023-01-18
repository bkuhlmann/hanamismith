# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Puma
      # Builds project skeleton Puma Procfile for production and development environments.
      class Procfile
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          builder.call(configuration.merge(template_path: "%project_name%/Procfile.erb")).render
          builder.call(configuration.merge(template_path: "%project_name%/Procfile.dev.erb")).render
          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
