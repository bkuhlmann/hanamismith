# frozen_string_literal: true

require "sod"

module Hanamismith
  module CLI
    module Commands
      # Handles the build command.
      class Build < Sod::Command
        include Hanamismith::Import[:input, :logger]

        # Order is important.
        BUILDERS = [
          Rubysmith::Builders::Init,
          Builders::Core,
          Builders::Providers::Persistence,
          Builders::Refinement,
          Builders::Icon,
          Builders::Stylesheet,
          Builders::HTMX,
          Builders::PWA,
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

        handle "build"

        description "Build new project."

        on Rubysmith::CLI::Actions::Name, input: Container[:input]
        on Rubysmith::CLI::Actions::AmazingPrint, input: Container[:input]
        on Rubysmith::CLI::Actions::Caliber, input: Container[:input]
        on Rubysmith::CLI::Actions::CircleCI, input: Container[:input]
        on Rubysmith::CLI::Actions::Citation, input: Container[:input]
        on Rubysmith::CLI::Actions::Community, input: Container[:input]
        on Rubysmith::CLI::Actions::Conduct, input: Container[:input]
        on Rubysmith::CLI::Actions::Console, input: Container[:input]
        on Rubysmith::CLI::Actions::Contributions, input: Container[:input]
        on Rubysmith::CLI::Actions::Debug, input: Container[:input]
        on Rubysmith::CLI::Actions::Funding, input: Container[:input]
        on Rubysmith::CLI::Actions::Git, input: Container[:input]
        on Rubysmith::CLI::Actions::GitHub, input: Container[:input]
        on Rubysmith::CLI::Actions::GitHubCI, input: Container[:input]
        on Rubysmith::CLI::Actions::GitLint, input: Container[:input]
        on Rubysmith::CLI::Actions::Guard, input: Container[:input]
        on Rubysmith::CLI::Actions::License, input: Container[:input]
        on Rubysmith::CLI::Actions::Maximum, input: Container[:input]
        on Rubysmith::CLI::Actions::Minimum, input: Container[:input]
        on Rubysmith::CLI::Actions::Rake, input: Container[:input]
        on Rubysmith::CLI::Actions::Readme, input: Container[:input]
        on Rubysmith::CLI::Actions::Reek, input: Container[:input]
        on Rubysmith::CLI::Actions::Refinements, input: Container[:input]
        on Rubysmith::CLI::Actions::RSpec, input: Container[:input]
        on Rubysmith::CLI::Actions::Security, input: Container[:input]
        on Rubysmith::CLI::Actions::Setup, input: Container[:input]
        on Rubysmith::CLI::Actions::SimpleCov, input: Container[:input]
        on Rubysmith::CLI::Actions::Versions, input: Container[:input]
        on Rubysmith::CLI::Actions::Yard, input: Container[:input]

        def initialize(builders: BUILDERS, **)
          super(**)
          @builders = builders
        end

        def call
          log_info "Building project skeleton: #{input.project_name}..."
          builders.each { |builder| builder.call input }
          log_info "Project skeleton complete!"
        end

        private

        attr_reader :builders

        def log_info(message) = logger.info { message }
      end
    end
  end
end
