# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::CircleCI do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application"

  describe "#call" do
    let(:path) { temp_dir.join "test/.circleci/config.yml" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_circle_ci: true }

      it "builds file" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          version: 2.1
          jobs:
            build:
              working_directory: ~/project
              docker:
                - image: bkuhlmann/alpine-ruby:latest
                  environment:
                    HANAMI_ENV: test
                    DATABASE_URL: postgres://postgres:postgres@localhost:5432/postgres
                - image: postgres:latest
                  environment:
                    POSTGRES_PASSWORD: postgres
              steps:
                - run:
                    name: Chromium Install
                    command: apk add gcompat glib nss libxcb libgcc chromium

                - run:
                    name: Chromium Start
                    command: |
                      export DISPLAY=:99
                      chromedriver --url-base=/wd/hub &

                - run:
                    name: Node Install
                    command: apk add nodejs npm

                - checkout

                - restore_cache:
                    name: Gems Restore
                    keys:
                      - gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                      - gem-cache-

                - run:
                    name: Gems Install
                    command: |
                      gem update --system
                      bundle config set path "vendor/bundle"
                      bundle install

                - save_cache:
                    name: Gems Store
                    key: gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                    paths:
                      - vendor/bundle

                - restore_cache:
                    name: Packages Restore
                    keys:
                      - package-cache-{{.Branch}}-{{checksum "package.json"}}
                      - package-cache-

                - run:
                    name: Packages Install
                    command: npm install

                - save_cache:
                    name: Packages Store
                    key: package-cache-{{.Branch}}-{{checksum "package.json"}}
                    paths:
                      - node_modules

                - run:
                    name: Database Setup
                    command: bin/hanami db prepare

                - run:
                    name: Build
                    command: |
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
        settings.merge! settings.minimize.merge build_circle_ci: true, build_simple_cov: true
      end

      it "builds file" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          version: 2.1
          jobs:
            build:
              working_directory: ~/project
              docker:
                - image: bkuhlmann/alpine-ruby:latest
                  environment:
                    HANAMI_ENV: test
                    DATABASE_URL: postgres://postgres:postgres@localhost:5432/postgres
                - image: postgres:latest
                  environment:
                    POSTGRES_PASSWORD: postgres
              steps:
                - run:
                    name: Chromium Install
                    command: apk add gcompat glib nss libxcb libgcc chromium

                - run:
                    name: Chromium Start
                    command: |
                      export DISPLAY=:99
                      chromedriver --url-base=/wd/hub &

                - run:
                    name: Node Install
                    command: apk add nodejs npm

                - checkout

                - restore_cache:
                    name: Gems Restore
                    keys:
                      - gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                      - gem-cache-

                - run:
                    name: Gems Install
                    command: |
                      gem update --system
                      bundle config set path "vendor/bundle"
                      bundle install

                - save_cache:
                    name: Gems Store
                    key: gem-cache-{{.Branch}}-{{checksum "Gemfile.lock"}}
                    paths:
                      - vendor/bundle

                - restore_cache:
                    name: Packages Restore
                    keys:
                      - package-cache-{{.Branch}}-{{checksum "package.json"}}
                      - package-cache-

                - run:
                    name: Packages Install
                    command: npm install

                - save_cache:
                    name: Packages Store
                    key: package-cache-{{.Branch}}-{{checksum "package.json"}}
                    paths:
                      - node_modules

                - run:
                    name: Database Setup
                    command: bin/hanami db prepare

                - run:
                    name: Build
                    command: |
                      bin/hanami assets compile
                      bundle exec rake

                - store_artifacts:
                    name: SimpleCov Archive
                    path: ~/project/coverage
                    destination: coverage
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
