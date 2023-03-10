# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Slices
      # Builds project skeleton foundation.
      class Main
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

        def add_action
          path = "%project_name%/slices/main/action.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end

        def add_repository
          path = "%project_name%/slices/main/repository.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end

        def add_view
          path = "%project_name%/slices/main/view.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end

        def add_layout_template
          path = "%project_name%/slices/main/templates/layouts/app.html.erb.erb"
          builder.call(configuration.merge(template_path: path))
                 .render
                 .replace("<!-- yield -->", "<%= yield %>")
        end

        def add_show_template
          path = "%project_name%/slices/main/templates/home/show.html.erb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end

        def add_show_view
          path = "%project_name%/slices/main/views/home/show.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end

        def add_show_action
          path = "%project_name%/slices/main/actions/home/show.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end
      end
    end
  end
end
