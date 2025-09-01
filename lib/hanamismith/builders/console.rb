# frozen_string_literal: true

require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton console for object inspection and exploration.
    class Console < Rubysmith::Builders::Console
      using Refinements::Struct

      def call
        return false unless settings.build_console

        super
        builder.call(settings.with(template_path: "%project_name%/bin/console.erb"))
               .replace(/require Bundler.root.+/, %(require "hanami/prepare"))

        add_irb_autocomplete

        true
      end

      private

      def add_irb_autocomplete
        with_template.insert_before "IRB.start", <<~CODE
          unless Hanami.env? :development, :test
            ENV["IRB_USE_AUTOCOMPLETE"] ||= "false"
            puts "IRB autocomplete disabled."
          end

        CODE
      end

      def with_template
        builder.call settings.with(template_path: "%project_name%/bin/console.erb")
      end
    end
  end
end
