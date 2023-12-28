# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton Rake support.
    class Rake < Rubysmith::Builders::Rake
      using Refinements::Struct

      def call
        return configuration unless configuration.build_rake

        super
        builder.call(configuration.merge(template_path: "%project_name%/Rakefile.erb"))
               .render
               .insert_after(%r(bundler/setup), %(require "hanami/rake_tasks"))

        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
