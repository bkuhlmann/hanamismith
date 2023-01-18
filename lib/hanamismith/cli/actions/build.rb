# frozen_string_literal: true

module Hanamismith
  module CLI
    module Actions
      # Handles the build action.
      class Build
        include Hanamismith::Import[:logger]

        # Order is important.
        BUILDERS = [
          Builders::Core,
          Builders::Slices::Main,
          Rubysmith::Builders::Version,
          Builders::Documentation::Readme,
          Rubysmith::Builders::Documentation::Citation,
          Rubysmith::Builders::Documentation::License,
          Rubysmith::Builders::Documentation::Version,
          Rubysmith::Builders::Git::Setup,
          Rubysmith::Builders::Git::Ignore,
          Builders::Bundler,
          Builders::Rake,
          Builders::Binstub,
          Builders::Console,
          Rubysmith::Builders::CircleCI,
          Rubysmith::Builders::Setup,
          Rubysmith::Builders::GitHub,
          Rubysmith::Builders::GitHubCI,
          Builders::Guard,
          Rubysmith::Builders::Reek,
          Rubysmith::Builders::RSpec::Binstub,
          Rubysmith::Builders::RSpec::Context,
          Builders::RSpec::ApplicationSharedContext,
          Builders::RSpec::Database,
          Builders::RSpec::Helper,
          Builders::RSpec::Hanami,
          Builders::Rack,
          Builders::Puma::Configuration,
          Builders::Puma::Procfile,
          Builders::Caliber,
          Rubysmith::Extensions::Bundler,
          Rubysmith::Extensions::Pragmater,
          Rubysmith::Extensions::Tocer,
          Rubysmith::Extensions::Rubocop,
          Builders::Environment,
          Builders::Git::Commit
        ].freeze

        def initialize builders: BUILDERS, **dependencies
          super(**dependencies)
          @builders = builders
        end

        def call configuration
          log_info "Building project skeleton: #{configuration.project_name}..."
          builders.each { |builder| builder.call configuration }
          log_info "Project skeleton complete!"
        end

        private

        attr_reader :builders

        def log_info(message) = logger.info { message }
      end
    end
  end
end
