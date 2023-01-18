# frozen_string_literal: true

require "dry/container"

module Hanamismith
  module CLI
    module Actions
      # Provides a single container of application and action specific dependencies.
      module Container
        extend Dry::Container::Mixin

        merge Hanamismith::Container

        register(:build) { Build.new }
        register(:config) { Config.new }
      end
    end
  end
end
