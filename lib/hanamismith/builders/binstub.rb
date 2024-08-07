# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton binstub.
    class Binstub < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        builder.call(settings.merge(template_path: "%project_name%/bin/hanami.erb"))
               .render
               .permit 0o755

        true
      end
    end
  end
end
