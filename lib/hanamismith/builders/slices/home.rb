# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Slices
      # Builds home slice skeleton.
      class Home
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
          path = "%project_name%/slices/home/action.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end

        def add_repository
          path = "%project_name%/slices/home/repository.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end

        def add_view
          path = "%project_name%/slices/home/view.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end

        def add_layout_template
          path = "%project_name%/slices/home/templates/layouts/app.html.erb.erb"
          builder.call(configuration.merge(template_path: path))
                 .render
                 .replace("<!-- title -->", "<%= content_for :title %>")
                 .replace("<!-- favicon -->", favicon)
                 .replace("<!-- manifest -->", manifest)
                 .replace("<!-- stylesheet -->", stylesheet)
                 .replace("<!-- yield -->", "<%= yield %>")
        end

        def favicon
          %(<%= favicon_tag "icon.svg", title: "#{configuration.project_label}: Icon", rel: ) +
            %(:icon, type: "image/svg+xml" %>)
        end

        def manifest
          %(<%= tag.link title: "#{configuration.project_label}: Manifest", rel: ) +
            %(:manifest, href: asset_url("manifest.webmanifest") %>)
        end

        def stylesheet
          %(<%= stylesheet_tag "home/app", title: "#{configuration.project_label}: Stylesheet" %>)
        end

        def add_show_template
          path = "%project_name%/slices/home/templates/show.html.erb.erb"

          builder.call(configuration.merge(template_path: path))
                 .render
                 .replace(
                   "<!-- title -->",
                   %(<% content_for :title, "#{configuration.project_label}" %>)
                 )
                 .replace("<!-- ruby_version -->", "<%= ruby_version %>")
                 .replace("<!-- hanami_version -->", "<%= hanami_version %>")
        end

        def add_show_view
          path = "%project_name%/slices/home/views/show.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end

        def add_show_action
          path = "%project_name%/slices/home/actions/show.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
        end
      end
    end
  end
end
