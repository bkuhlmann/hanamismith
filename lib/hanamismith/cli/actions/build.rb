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
          Builders::Providers::Persistence,
          Builders::Providers::RackAttack,
          Builders::Refinement,
          Builders::Stylesheet,
          Builders::HTMX,
          Builders::Slices::Main,
          Builders::Slices::Health,
          Rubysmith::Builders::Version,
          Builders::Documentation::Readme,
          Rubysmith::Builders::Documentation::Citation,
          Rubysmith::Builders::Documentation::License,
          Rubysmith::Builders::Documentation::Version,
          Rubysmith::Builders::Git::Setup,
          Rubysmith::Builders::Git::Ignore,
          Rubysmith::Builders::Git::Safe,
          Builders::Bundler,
          Builders::Rake,
          Builders::Binstub,
          Builders::Console,
          Builders::CI::Circle,
          Builders::CI::GitHub,
          Rubysmith::Builders::Setup,
          Rubysmith::Builders::GitHub,
          Builders::Guard,
          Rubysmith::Builders::Reek,
          Rubysmith::Builders::RSpec::Binstub,
          Rubysmith::Builders::RSpec::Context,
          Builders::RSpec::ApplicationSharedContext,
          Builders::RSpec::Database,
          Builders::RSpec::Factory,
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
          Builders::Environments::Development,
          Builders::Environments::Test,
          Builders::Git::Commit
        ].freeze

        def initialize(builders: BUILDERS, **)
          super(**)
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
