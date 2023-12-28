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
          @instance = builder.call configuration.merge(
            template_path: "%project_name%/spec/spec_helper.rb.erb"
          )
        end

        def call
          return configuration unless configuration.build_rspec

          super
          remove_project_requirement
          disable_simple_cov_eval
          configuration
        end

        private

        attr_reader :instance

        def remove_project_requirement
          instance.replace(/require.+#{configuration.project_name}.+\n/, "")
        end

        def disable_simple_cov_eval
          instance.replace(
            /enable_coverage_for_eval\n/,
            "# TODO: Enable once this issue is fixed: " \
            "https://bugs.ruby-lang.org/issues/19363.\n    " \
            "# enable_coverage_for_eval\n"
          )
        end
      end
    end
  end
end
