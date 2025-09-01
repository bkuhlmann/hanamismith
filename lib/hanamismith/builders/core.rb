# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton foundation.
    class Core < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        private_methods.grep(/\Aadd_/).sort.each { |method| __send__ method }
        true
      end

      private

      def add_db_relation
        builder.call(settings.with(template_path: "%project_name%/app/db/relation.rb.erb")).render
      end

      def add_db_repository
        builder.call(settings.with(template_path: "%project_name%/app/db/repository.rb.erb")).render
      end

      def add_db_struct
        builder.call(settings.with(template_path: "%project_name%/app/db/struct.rb.erb")).render
      end

      def add_action
        builder.call(settings.with(template_path: "%project_name%/app/action.rb.erb")).render
      end

      def add_view
        builder.call(settings.with(template_path: "%project_name%/app/view.rb.erb")).render
      end

      def add_application_configuration
        builder.call(settings.with(template_path: "%project_name%/config/app.rb.erb")).render
      end

      def add_routes_configuration
        builder.call(settings.with(template_path: "%project_name%/config/routes.rb.erb")).render
      end

      def add_settings_configuration
        builder.call(settings.with(template_path: "%project_name%/config/settings.rb.erb")).render
      end

      def add_types
        path = "%project_name%/lib/%project_path%/types.rb.erb"
        builder.call(settings.with(template_path: path)).render
      end

      def add_migrate_directory
        builder.call(settings.with(template_path: "%project_name%/db/migrate")).make_path
      end

      def add_well_known_security_text
        return unless settings.build_security

        path = "%project_name%/public/.well-known/security.txt.erb"
        builder.call(settings.with(template_path: path)).render
      end

      def add_public_http_errors
        %w[404 500].each do |code|
          path = "%project_name%/public/#{code}.html.erb"
          builder.call(settings.with(template_path: path)).render
        end
      end

      def add_temp_directory
        builder.call(settings.with(template_path: "%project_name%/tmp")).make_path
      end
    end
  end
end
