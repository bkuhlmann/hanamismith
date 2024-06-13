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
          builder.call(settings.merge(template_path: "%project_name%/.gitignore.erb"))
                 .insert_before "tmp\n", <<~CONTENT
                   node_modules
                   public/assets
                   public/assets.json
                 CONTENT

          true
        end
      end
    end
  end
end
