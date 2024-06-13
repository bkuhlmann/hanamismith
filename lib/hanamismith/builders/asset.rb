# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton for assets.
    class Asset < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        path = "%project_name%/config/assets.js.erb"
        builder.call(settings.merge(template_path: path)).render
        true
      end
    end
  end
end
