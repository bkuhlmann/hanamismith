# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton foundation.
    class Core
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Rubysmith::Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        private_methods.grep(/\Aadd_/).sort.each { |method| __send__ method }
        configuration
      end

      private

      attr_reader :configuration, :builder

      def add_application_action
        builder.call(configuration.merge(template_path: "%project_name%/app/action.rb.erb")).render
      end

      def add_application_repository
        builder.call(configuration.merge(template_path: "%project_name%/app/repo.rb.erb")).render
      end

      def add_application_view
        builder.call(configuration.merge(template_path: "%project_name%/app/view.rb.erb")).render
      end

      def add_persistence_provider
        path = "%project_name%/config/providers/persistence.rb.erb"
        builder.call(configuration.merge(template_path: path)).render
      end

      def add_application_configuration
        builder.call(configuration.merge(template_path: "%project_name%/config/app.rb.erb")).render
      end

      def add_routes_configuration
        builder.call(configuration.merge(template_path: "%project_name%/config/routes.rb.erb"))
               .render
      end

      def add_settings_configuration
        builder.call(configuration.merge(template_path: "%project_name%/config/settings.rb.erb"))
               .render
      end

      def add_types
        path = "%project_name%/lib/%project_path%/types.rb.erb"
        builder.call(configuration.merge(template_path: path)).render
      end
    end
  end
end
