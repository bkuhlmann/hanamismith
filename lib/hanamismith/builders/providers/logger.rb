# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Providers
      # Builds project skeleton for logger provider.
      class Logger < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          build_all
          add_initializers
          true
        end

        private

        def build_all
          %w[
            %project_name%/app/providers/logger.rb.erb
            %project_name%/spec/app/providers/logger_spec.rb.erb
            %project_name%/config/providers/logger.rb.erb
            %project_name%/app/aspects/logging/rack_adapter.rb.erb
            %project_name%/spec/app/aspects/logging/rack_adapter_spec.rb.erb
            %project_name%/config/initializers/rack_logger_patch.rb.erb
            %project_name%/config/initializers/sql_logger_patch.rb.erb
          ].each { build it }
        end

        def build(path) = builder.call(settings.with(template_path: path)).render

        def add_initializers
          builder.call(settings.with(template_path: "%project_name%/config/app.rb.erb"))
                 .insert_after(
                   /require/,
                   <<~REQUIRES

                     require_relative "initializers/rack_logger_patch"
                     require_relative "initializers/sql_logger_patch"
                   REQUIRES
                 )
        end
      end
    end
  end
end
