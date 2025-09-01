# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module RSpec
      # Builds project skeleton RSpec application shared context.
      class ApplicationSharedContext < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_rspec

          path = "%project_name%/spec/support/shared_contexts/application.rb.erb"
          builder.call(settings.with(template_path: path)).render

          true
        end
      end
    end
  end
end
