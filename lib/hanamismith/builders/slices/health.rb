# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Slices
      # Builds health slice skeleton.
      class Health < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          private_methods.grep(/\Aadd_/).sort.each { |method| __send__ method }
          true
        end

        private

        def add_configuration
          path = "%project_name%/config/slices/health.rb.erb"
          builder.call(settings.with(template_path: path)).render
        end

        def add_action
          path = "%project_name%/slices/health/action.rb.erb"
          builder.call(settings.with(template_path: path)).render
        end

        def add_view
          path = "%project_name%/slices/health/view.rb.erb"
          builder.call(settings.with(template_path: path)).render
        end

        def add_show_template
          path = "%project_name%/slices/health/templates/show.html.erb.erb"

          builder.call(settings.with(template_path: path))
                 .render
                 .replace(
                   "<!-- title -->",
                   %(<% content_for :title, "Health | #{settings.project_label}" %>)
                 )
                 .replace("<!-- color -->", %(<%= color %>))
        end

        def add_context
          path = "%project_name%/slices/health/views/context.rb.erb"
          builder.call(settings.with(template_path: path)).render
        end

        def add_show_view
          path = "%project_name%/slices/health/views/show.rb.erb"
          builder.call(settings.with(template_path: path)).render
        end

        def add_show_action
          path = "%project_name%/slices/health/actions/show.rb.erb"
          builder.call(settings.with(template_path: path)).render
        end

        def add_show_action_spec
          path = "%project_name%/spec/slices/health/actions/show_spec.rb.erb"
          builder.call(settings.with(template_path: path)).render
        end
      end
    end
  end
end
