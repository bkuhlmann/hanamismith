# frozen_string_literal: true

require "dry/monads"
require "refinements/pathname"
require "refinements/struct"

module Hanamismith
  module Builders
    # Builds project skeleton for Node.
    class Node < Rubysmith::Builders::Abstract
      include Dry::Monads[:result]

      using Refinements::Struct
      using Refinements::Pathname

      def initialize(executor: Open3, **)
        @executor = executor
        super(**)
      end

      def call
        build_version
        builder.call(settings.with(template_path: "%project_name%/package.json.erb")).render
        true
      end

      private

      attr_reader :executor

      def build_version
        case load_version
          in Success(text) then version_path.make_ancestors.write text.delete_prefix("v")
          in Failure(message) then log_error message
          else log_error "Shell failure. Is your environment configured properly?"
        end
      end

      def load_version
        executor.capture3("node", "--version").then do |stdout, _stderr, status|
          return Success stdout if status.success?

          Failure "Unable to obtain version for #{version_path.inspect}."
        end
      rescue Errno::ENOENT
        Failure "Unable to find Node. Is Node installed?"
      end

      def version_path = settings.project_root.join ".node-version"

      def log_error(message) = logger.error { message }
    end
  end
end
