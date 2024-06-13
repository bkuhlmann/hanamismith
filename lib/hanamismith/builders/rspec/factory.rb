# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module RSpec
      # Builds project skeleton RSpec application database support.
      class Factory < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_rspec

          path = "%project_name%/spec/support/factory.rb.erb"
          builder.call(settings.merge(template_path: path)).render

          true
        end
      end
    end
  end
end
