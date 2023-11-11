# frozen_string_literal: true

require "refinements/ios"
require "refinements/pathnames"
require "rubocop"

module Hanamismith
  module Extensions
    # Ensures NPM packages are installed if NPM is available.
    class NPM
      include Import[:kernel, :logger]

      using Refinements::IOs
      using Refinements::Pathnames

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
