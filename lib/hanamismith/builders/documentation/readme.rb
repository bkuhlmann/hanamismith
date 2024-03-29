# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme < Rubysmith::Builders::Documentation::Readme
        using Refinements::Struct

        def call
          return configuration unless configuration.build_readme

          super
          builder.call(configuration.merge(template_path: "%project_name%/README.#{kind}.erb"))
                 .replace(/Setup.+Usage/m, setup)
                 .replace("Rubysmith", "Hanamismith")
                 .replace("rubysmith", "hanamismith")

          configuration
        end

        private

        attr_reader :configuration, :builder

        def kind = configuration.documentation_format

        def setup = kind == "adoc" ? ascii_setup : markdown_setup

        # rubocop:disable Metrics/MethodLength
        def ascii_setup
          <<~CONTENT.strip
            Setup

            To set up the project, run:

            [source,bash]
            ----
            git clone #{configuration.computed_project_url_source}
            cd #{configuration.project_name}
            bin/setup
            ----

            == Usage
          CONTENT
        end

        def markdown_setup
          <<~CONTENT.strip
            Setup

            To set up the project, run:

            ``` bash
            git clone #{configuration.computed_project_url_source}
            cd #{configuration.project_name}
            bin/setup
            ```

            ## Usage
          CONTENT
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
