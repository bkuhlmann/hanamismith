# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::GitHub::CI do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  let(:yaml_path) { temp_dir.join "test/.github/workflows/ci.yml" }

  include_context "with application dependencies"

  describe "#call" do
    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_git_hub_ci: true }

      it "does not build YAML template" do
        builder.call

        expect(yaml_path.read).to eq(<<~CONTENT)
          name: Continuous Integration

          on: [push, pull_request]

          jobs:
            build:
              name: Build
              runs-on: ubuntu-latest
              env:
                HANAMI_ENV: test
                DATABASE_URL: postgres://postgres:postgres@localhost:5432/postgres

              services:
                postgres:
                  image: postgres:latest
                  env:
                    POSTGRES_PASSWORD: postgres
                  ports:
                    - 5432:5432
                  options: >-
                    --health-cmd pg_isready
                    --health-interval 10s
                    --health-timeout 5s
                    --health-retries 5

              steps:
                - name: Chromium Setup
                  uses: nanasess/setup-chromedriver@v2

                - name: Chromium Start
                  run: |
                    export DISPLAY=:99
                    chromedriver --url-base=/wd/hub &

                - name: Checkout
                  uses: actions/checkout@v4

                - name: Ruby Setup
                  uses: ruby/setup-ruby@v1
                  with:
                    bundler-cache: true

                - name: Node Setup
                  uses: actions/setup-node@v2
                  with:
                    cache: npm

                - name: Packages Install
                  run: npm install

                - name: Database Setup
                  run: |
                    bin/hanami db create
                    bin/hanami db migrate

                - name: Build
                  run: |
                    bin/hanami assets compile
                    bundle exec rake
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with SimpleCov" do
      before do
        settings.merge! settings.minimize.merge build_git_hub_ci: true, build_simple_cov: true
      end

      it "does not build YAML template" do
        builder.call

        expect(yaml_path.read).to eq(<<~CONTENT)
          name: Continuous Integration

          on: [push, pull_request]

          jobs:
            build:
              name: Build
              runs-on: ubuntu-latest
              env:
                HANAMI_ENV: test
                DATABASE_URL: postgres://postgres:postgres@localhost:5432/postgres

              services:
                postgres:
                  image: postgres:latest
                  env:
                    POSTGRES_PASSWORD: postgres
                  ports:
                    - 5432:5432
                  options: >-
                    --health-cmd pg_isready
                    --health-interval 10s
                    --health-timeout 5s
                    --health-retries 5

              steps:
                - name: Chromium Setup
                  uses: nanasess/setup-chromedriver@v2

                - name: Chromium Start
                  run: |
                    export DISPLAY=:99
                    chromedriver --url-base=/wd/hub &

                - name: Checkout
                  uses: actions/checkout@v4

                - name: Ruby Setup
                  uses: ruby/setup-ruby@v1
                  with:
                    bundler-cache: true

                - name: Node Setup
                  uses: actions/setup-node@v2
                  with:
                    cache: npm

                - name: Packages Install
                  run: npm install

                - name: Database Setup
                  run: |
                    bin/hanami db create
                    bin/hanami db migrate

                - name: Build
                  run: |
                    bin/hanami assets compile
                    bundle exec rake

                - name: SimpleCov Archive
                  uses: actions/upload-artifact@v4
                  with:
                    name: coverage
                    path: coverage
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "does not build YAML template" do
        builder.call
        expect(yaml_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
