# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton Progressive Web Application (PWA) manifest.
    class PWA < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        path = "%project_name%/app/assets/pwa/manifest.webmanifest.erb"
        builder.call(settings.with(template_path: path)).render
        true
      end
    end
  end
end
