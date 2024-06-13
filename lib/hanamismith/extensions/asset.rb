# frozen_string_literal: true

require "refinements/pathname"

module Hanamismith
  module Extensions
    # Ensures assets are compiled.
    class Asset
      include Import[:settings, :kernel, :logger]

      using Refinements::Pathname

      def call
        logger.error { "Unable to compile assets. Try: `hanami assets compile`." } unless run
        true
      end

      private

      def run
        success = false
        settings.project_root.change_dir { success = compile_app && compile_home }
        success
      end

      def compile_app
        kernel.system "node config/assets.js -- --path=app --dest=public/assets > /dev/null 2>&1"
      end

      def compile_home
        kernel.system(
          "node config/assets.js -- --path=slices/home --dest=public/assets/_home > /dev/null 2>&1"
        )
      end
    end
  end
end
