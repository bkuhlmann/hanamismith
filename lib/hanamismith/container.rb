# frozen_string_literal: true

require "cogger"
require "dry/container"
require "spek"

module Hanamismith
  # Provides a global gem container for injection into other objects.
  module Container
    extend Dry::Container::Mixin

    register(:configuration) { Configuration::Loader.call }
    register(:specification) { Spek::Loader.call "#{__dir__}/../../hanamismith.gemspec" }
    register(:kernel) { Kernel }
    register(:logger) { Cogger::Client.new }
  end
end
