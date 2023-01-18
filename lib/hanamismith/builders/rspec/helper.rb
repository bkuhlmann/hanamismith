# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module RSpec
      # Builds project skeleton RSpec helper.
      class Helper < Rubysmith::Builders::RSpec::Helper
        using Refinements::Structs

        def call
          return configuration unless configuration.build_rspec

          super
          path = "%project_name%/spec/spec_helper.rb.erb"
          builder.call(configuration.merge(template_path: path))
                 .replace(/require.+#{configuration.project_name}.+\n/, "")
          configuration
        end
      end
    end
  end
end
