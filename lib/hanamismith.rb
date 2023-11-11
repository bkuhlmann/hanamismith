# frozen_string_literal: true

require "rubysmith"
require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "cli" => "CLI",
                           "ci" => "CI",
                           "htmx" => "HTMX",
                           "npm" => "NPM",
                           "pwa" => "PWA",
                           "rspec" => "RSpec"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Hanamismith
  def self.loader registry = Zeitwerk::Registry
    @loader ||= registry.loaders.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
  end
end
