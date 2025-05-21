# frozen_string_literal: true

require "rubysmith"
require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.inflector.inflect "cli" => "CLI",
                           "ci" => "CI",
                           "circle_ci" => "CircleCI",
                           "htmx" => "HTMX",
                           "npm" => "NPM",
                           "pwa" => "PWA",
                           "rspec" => "RSpec",
                           "yjit" => "YJIT"
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Hanamismith
  def self.loader registry = Zeitwerk::Registry
    @loader ||= registry.loaders.each.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
  end
end
