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
               .replace("<!-- favicon -->", favicon)
               .replace("<!-- icon -->", icon)
               .replace("<!-- apple_icon -->", apple_icon)
               .replace("<!-- manifest -->", manifest)
               .replace("<!-- stylesheet -->", stylesheet)
               .replace("<!-- javascript -->", javascript)
               .replace("<!-- yield -->", "<%= yield %>")
               .replace("<!-- flash:alert -->", flash(:alert))
               .replace("<!-- flash:notice -->", flash(:notice))

        true
      end

      private

      def favicon
        uri = "https://alchemists.io/images/projects/hanamismith/icons/favicon.ico"

        %(<%= tag.link title: "#{settings.project_label}: Favicon",\n) +
          %(                 rel: :icon,\n) +
          %(                 href: "#{uri}",\n) +
          %(                 sizes: "32x32" %>)
      end

      def icon
        %(<%= tag.link title: "#{settings.project_label}: Icon",\n) +
          %(                 rel: :icon,\n) +
          %(                 href: app_assets["icon.svg"],\n) +
          %(                 type: "image/svg+xml" %>)
      end

      def apple_icon
        uri = "https://alchemists.io/images/projects/hanamismith/icons/apple.png"

        %(<%= tag.link title: "#{settings.project_label}: Apple Icon",\n) +
          %(                 rel: "apple-touch-icon",\n) +
          %(                 href: "#{uri}",\n) +
          %(                 type: "image/png" %>)
      end

      # :reek:UtilityFunction
      def flash kind
        %(<% if flash[:#{kind}] %>\n) +
          %(      <div class="site-#{kind}">\n) +
          %(        <p><%= flash[:#{kind}] %></p>\n) +
          %(      </div>\n) +
          %(    <% end %>\n)
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

      def javascript = %(<%= tag.script src: app_assets["app.js"], type: "text/javascript" %>)
    end
  end
end
