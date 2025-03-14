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
          @template = builder.call settings.merge(
            template_path: "%project_name%/spec/spec_helper.rb.erb"
          )
        end

        def call
          return false unless settings.build_rspec

          super
          private_methods.grep(/\Aadd_/).sort.each { |method| __send__ method }
          true
        end

        private

        attr_reader :template

        def add_monad_requirement
          template.replace(/require.+#{settings.project_name}.+\n/, %(require "dry/monads"\n))
        end

        def add_simple_cov_eval_adjustment
          template.replace(/\s{4}enable_coverage_for_eval\n/, "")
        end

        def add_monad_configuration
          template.append <<~CONTENT
            # insert
              config.before(:suite) { Dry::Monads.load_extensions :rspec }
            end
          CONTENT

          template.replace "end\n# insert", ""
        end
      end
    end
  end
end
