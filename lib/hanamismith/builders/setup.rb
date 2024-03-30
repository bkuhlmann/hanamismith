# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton setup script.
    class Setup < Rubysmith::Builders::Setup
      using Refinements::Struct

      def call
        return configuration unless configuration.build_setup

        super
        append
        configuration
      end

      private

      def append
        builder.call(configuration.merge(template_path: "%project_name%/bin/setup.erb"))
               .insert_after(%(Runner.call "bundle install"\n), <<~CONTENT.gsub(/^(?=\w)/, "  "))

                 puts "Installing packages..."
                 Runner.call "npm install"

                 puts "Configurating databases..."
                 Runner.call "bin/hanami db create"
                 Runner.call "bin/hanami db migrate"
                 Runner.call "HANAMI_ENV=test bin/hanami db create"
                 Runner.call "HANAMI_ENV=test bin/hanami db migrate"
               CONTENT
      end
    end
  end
end
