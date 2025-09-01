# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Rake
      # Builds project skeleton Rake configuration file.
      class Configuration < Rubysmith::Builders::Rake::Configuration
        using Refinements::Struct

        def call
          return false unless settings.build_rake

          super
          builder.call(settings.with(template_path: "%project_name%/Rakefile.erb"))
                 .render
                 .insert_after(%r(bundler/setup), %(require "hanami/rake_tasks"))

          true
        end
      end
    end
  end
end
