# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module RSpec
      # Builds project skeleton RSpec helper.
      class Hanami < Rubysmith::Builders::Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_rspec

          path = "%project_name%/spec/hanami_helper.rb.erb"
          builder.call(configuration.merge(template_path: path)).render

          configuration
        end
      end
    end
  end
end
