# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Git
      # Builds project skeleton Git ignore.
      class Ignore < Rubysmith::Builders::Git::Ignore
        using Refinements::Struct

        def call
          return false unless settings.build_git

          super
          add_entries
          true
        end

        private

        def add_entries
          builder.call(settings.with(template_path: "%project_name%/.gitignore.erb"))
                 .insert_before "tmp\n", <<~CONTENT
                   node_modules
                   public/*
                   !public/.well-known
                   !public/404.html
                   !public/500.html
                 CONTENT
        end
      end
    end
  end
end
