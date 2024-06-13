# frozen_string_literal: true

require "refinements/io"
require "refinements/pathname"

module Hanamismith
  module Extensions
    # Ensures NPM packages are installed if NPM is available.
    class NPM
      include Import[:settings, :kernel, :logger]

      using Refinements::IO
      using Refinements::Pathname

      def call
        logger.error { "Unable to detect NPM. Install NPM and run: `npm install`." } unless run
        true
      end

      private

      def run
        success = false

        settings.project_root.change_dir do
          STDOUT.squelch { success = kernel.system "command -v npm && npm install" }
        end

        success
      end
    end
  end
end
