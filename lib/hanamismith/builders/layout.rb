# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds app layout.
    class Layout < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        path = "%project_name%/app/templates/layouts/app.html.erb.erb"
        builder.call(settings.with(template_path: path))
               .render
               .replace("<!-- title -->", "<%= content_for :title %>")
               .replace("<!-- icon -->", icon)
               .replace("<!-- manifest -->", manifest)
               .replace("<!-- stylesheet -->", stylesheet)
               .replace("<!-- yield -->", "<%= yield %>")

        true
      end

      private

      def icon
        %(<%= tag.link title: "#{settings.project_label}: Icon",\n) +
          %(                 rel: :icon,\n) +
          %(                 href: app_assets["icon.svg"],\n) +
          %(                 type: "image/svg+xml" %>)
      end

      def manifest
        %(<%= tag.link title: "#{settings.project_label}: Manifest",\n) +
          %(                 rel: :manifest,\n) +
          %(                 href: app_assets["manifest.webmanifest"] %>)
      end

      def stylesheet
        %(<%= tag.link title: "#{settings.project_label}: Stylesheet", rel: :stylesheet, ) +
          %(href: app_assets["app.css"] %>)
      end
    end
  end
end
