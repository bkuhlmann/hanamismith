# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Git
      # Builds project skeleton Git ignore.
      class Ignore < Rubysmith::Builders::Git::Ignore
        using Refinements::Struct

        def call
          return configuration unless configuration.build_git

          super
          builder.call(configuration.merge(template_path: "%project_name%/.gitignore.erb"))
                 .insert_before("tmp\n", "node_modules\n")
                 .insert_before("tmp\n", "public/assets\n")
                 .insert_before("tmp\n", "public/assets.json\n")

          configuration
        end
      end
    end
  end
end
