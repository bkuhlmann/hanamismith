# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton for Node.
    class Node < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        builder.call(settings.merge(template_path: "%project_name%/package.json.erb")).render
        builder.call(settings.merge(template_path: "%project_name%/.node-version.erb")).render
        true
      end
    end
  end
end
