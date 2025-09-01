# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton foundation.
    class Refinement < Rubysmith::Builders::Abstract
      using Refinements::Struct

      def call
        %w[
          %project_name%/lib/%project_path%/refines/actions/response.rb.erb
          %project_name%/spec/lib/%project_path%/refines/actions/response_spec.rb.erb
        ].each do |path|
          builder.call(settings.with(template_path: path)).render
        end

        true
      end
    end
  end
end
