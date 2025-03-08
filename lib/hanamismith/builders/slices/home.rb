# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Slices
      # Builds home slice skeleton.
      class Home < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          private_methods.grep(/\Aadd_/).sort.each { |method| __send__ method }
          true
        end

        private

        def add_configuration
          path = "%project_name%/config/slices/home.rb.erb"
          builder.call(settings.merge(template_path: path)).render
        end

        def add_action
          path = "%project_name%/slices/home/action.rb.erb"
          builder.call(settings.merge(template_path: path)).render
        end

        def add_repository
          path = "%project_name%/slices/home/repository.rb.erb"
          builder.call(settings.merge(template_path: path)).render
        end

        def add_view
          path = "%project_name%/slices/home/view.rb.erb"
          builder.call(settings.merge(template_path: path)).render
        end

        def add_context
          path = "%project_name%/slices/home/views/context.rb.erb"
          builder.call(settings.merge(template_path: path)).render
        end

        def add_show_template
          path = "%project_name%/slices/home/templates/show.html.erb.erb"

          builder.call(settings.merge(template_path: path))
                 .render
                 .replace(
                   "<!-- title -->",
                   %(<% content_for :title, "#{settings.project_label}" %>)
                 )
                 .replace("<!-- ruby_version -->", "<%= ruby_version %>")
                 .replace("<!-- hanami_version -->", "<%= hanami_version %>")
        end

        def add_show_view
          path = "%project_name%/slices/home/views/show.rb.erb"
          builder.call(settings.merge(template_path: path)).render
        end

        def add_show_action
          path = "%project_name%/slices/home/actions/show.rb.erb"
          builder.call(settings.merge(template_path: path)).render
        end

        def add_request_spec
          path = "%project_name%/spec/features/home_spec.rb.erb"
          builder.call(settings.merge(template_path: path)).render
        end
      end
    end
  end
end
