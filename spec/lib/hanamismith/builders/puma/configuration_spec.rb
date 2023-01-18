# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Puma::Configuration do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:test_configuration) { configuration.minimize }

    before { builder.call }

    it "builds configuration" do
      expect(temp_dir.join("test/config/puma.rb").read).to eq(<<~CONTENT)
        development = ENV.fetch("HANAMI_ENV", "development") == "development"

        require "concurrent"
        require "localhost" if development
        Bundler.require :tools if development

        max_threads_count = ENV.fetch "HANAMI_MAX_THREADS", 5
        min_threads_count = ENV.fetch "HANAMI_MIN_THREADS", max_threads_count
        threads min_threads_count, max_threads_count

        port ENV.fetch "HANAMI_PORT", 2300
        environment ENV.fetch "HANAMI_ENV", "development"
        workers ENV.fetch "HANAMI_WEB_CONCURRENCY", Concurrent.physical_processor_count
        worker_timeout 3600 if development
        ssl_bind "localhost", "9050" if development
        pidfile ENV.fetch "PIDFILE", "tmp/server.pid"
        on_worker_boot { Hanami.shutdown }
        plugin :tmp_restart

        preload_app!
      CONTENT
    end
  end
end
