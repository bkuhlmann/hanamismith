# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    # Builds project skeleton console for object inspection and exploration.
    class Console < Rubysmith::Builders::Console
      using Refinements::Structs

      def call
        return configuration unless configuration.build_console

        super
        builder.call(configuration.merge(template_path: "%project_name%/bin/console.erb"))
               .replace(/require.+#{configuration.project_path}"/, %(require "hanami/prepare"))
        add_irb_autocomplete

        configuration
      end

      private

      def add_irb_autocomplete
        with_template.insert_before "IRB.start",
                                    <<~CODE
                                      unless Hanami.env? :development, :test
                                        ENV["IRB_USE_AUTOCOMPLETE"] ||= "false"
                                        puts "IRB autocomplete disabled."
                                      end

                                    CODE
      end

      def with_template
        builder.call configuration.merge(template_path: "%project_name%/bin/console.erb")
      end
    end
  end
end
