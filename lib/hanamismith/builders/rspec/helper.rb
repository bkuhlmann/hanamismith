# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module RSpec
      # Builds project skeleton RSpec helper.
      class Helper < Rubysmith::Builders::RSpec::Helper
        using Refinements::Struct

        def initialize(...)
          super
          @template = builder.call settings.with(
            template_path: "%project_name%/spec/spec_helper.rb.erb"
          )
        end

        def call
          return false unless settings.build_rspec

          super
          remove_project_requirement
          disable_simple_cov_eval
          true
        end

        private

        attr_reader :template

        def remove_project_requirement
          template.replace(/require.+#{settings.project_name}.+\n/, "")
        end

        def disable_simple_cov_eval
          template.replace(/\s{4}enable_coverage_for_eval\n/, "")
        end
      end
    end
  end
end
