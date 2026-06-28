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
          process
          true
        end

        private

        def process
          builder.call(settings.with(template_path: "%project_name%/Rakefile.erb"))
                 .render
                 .replace(
                   "Reek::Rake::Task.new",
                   %(Reek::Rake::Task.new { it.source_files = "{app,config,lib,slices}/**/*.rb" })
                 )
                 .insert_after(%r(bundler/setup), %(require "hanami/rake_tasks"))
                 .insert_after(/RuboCop::RakeTask/, %(\nRake.add_rakelib "lib/tasks"\n))
        end
      end
    end
  end
end
