# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Puma::Configuration do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application dependencies"

  describe "#call" do
    it "builds file" do
      settings.merge! settings.minimize
      builder.call

      expect(temp_dir.join("test/config/puma.rb").read).to eq(<<~CONTENT)
        development = ENV.fetch("HANAMI_ENV", "development") == "development"

        require "concurrent"
        require "localhost" if development

        Bundler.require :tools if development
        Bundler.root.join("tmp").then { |path| path.mkdir unless path.exist? }

        max_threads = ENV.fetch "HANAMI_MAX_THREADS", 5
        min_threads = ENV.fetch "HANAMI_MIN_THREADS", max_threads
        concurrency = ENV.fetch "HANAMI_WEB_CONCURRENCY", Concurrent.physical_processor_count

        threads min_threads, max_threads
        port ENV.fetch "HANAMI_PORT", 2300
        environment ENV.fetch "HANAMI_ENV", "development"
        workers concurrency
        worker_timeout 3600 if development
        ssl_bind "localhost", 2443 if development
        pidfile ENV.fetch "PIDFILE", "tmp/server.pid"
        plugin :tmp_restart

        preload_app! && before_fork { Hanami.shutdown } if concurrency.to_i.positive?
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
