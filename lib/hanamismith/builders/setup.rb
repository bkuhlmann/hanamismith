# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton setup script.
    class Setup < Rubysmith::Builders::Setup
      using Refinements::Structs

      def call
        return configuration unless configuration.build_setup

        super
        append
        configuration
      end

      private

      def append
        builder.call(configuration.merge(template_path: "%project_name%/bin/setup.erb"))
               .append(<<~CONTENT)

                 hanami db create
                 hanami db migrate
                 hanami db seed

                 HANAMI_ENV=test hanami db create
                 HANAMI_ENV=test hanami db migrate
               CONTENT
      end
    end
  end
end
