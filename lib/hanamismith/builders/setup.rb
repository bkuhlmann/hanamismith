# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton setup script.
    class Setup < Rubysmith::Builders::Setup
      using Refinements::Struct

      def call
        return false unless settings.build_setup

        super
        append
        true
      end

      private

      def append
        builder.call(settings.merge(template_path: "%project_name%/bin/setup.erb"))
               .insert_after(%(Runner.call "bundle install"\n), <<~CONTENT.gsub(/^(?=\w)/, "  "))

                 puts "Installing packages..."
                 Runner.call "npm install"

                 puts "Configuring databases..."
                 Runner.call "hanami db prepare"

                 puts "Compiling assets..."
                 Runner.call "hanami assets compile"
               CONTENT
      end
    end
  end
end
