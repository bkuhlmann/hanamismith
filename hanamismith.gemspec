# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "hanamismith"
  spec.version = "0.50.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/hanamismith"
  spec.summary = "A command line interface for smithing Hanami projects."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/hanamismith/issues",
    "changelog_uri" => "https://alchemists.io/projects/hanamismith/versions",
    "homepage_uri" => "https://alchemists.io/projects/hanamismith",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Hanamismith",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/hanamismith"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = ">= 3.3", "<= 3.4"
  spec.add_dependency "cogger", "~> 0.31"
  spec.add_dependency "containable", "~> 0.2"
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_dependency "dry-schema", "~> 1.13"
  spec.add_dependency "etcher", "~> 2.7"
  spec.add_dependency "htmx", "~> 1.0"
  spec.add_dependency "infusible", "~> 3.12"
  spec.add_dependency "refinements", "~> 12.10"
  spec.add_dependency "rubysmith", "~> 7.9"
  spec.add_dependency "runcom", "~> 11.10"
  spec.add_dependency "sod", "~> 0.20"
  spec.add_dependency "spek", "~> 3.0"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.bindir = "exe"
  spec.executables << "hanamismith"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir.glob ["*.gemspec", "lib/**/*"], File::FNM_DOTMATCH
end
