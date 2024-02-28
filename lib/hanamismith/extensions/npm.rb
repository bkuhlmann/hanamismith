# frozen_string_literal: true

require "refinements/io"
require "refinements/pathname"

module Hanamismith
  module Extensions
    # Ensures NPM packages are installed if NPM is available.
    class NPM
      include Import[:kernel, :logger]

      using Refinements::IO
      using Refinements::Pathname

      def self.call(...) = new(...).call

      def initialize(configuration, **)
        super(**)
        @configuration = configuration
      end

      def call
        logger.error { "Unable to detect NPM. Install NPM and run: `npm install`." } unless run
        configuration
      end

      private

      attr_reader :configuration

      def run
        success = false

        configuration.project_root.change_dir do
          STDOUT.squelch { success = kernel.system "command -v npm && npm install" }
        end

        success
      end
    end
  end
end
