# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Guard do
  using Refinements::Struct

  subject(:builder) { described_class.new settings: }

  include_context "with application dependencies"

  let(:configuration_path) { temp_dir.join "test", "Guardfile" }

  describe "#call" do
    context "when enabled" do
      before { settings.merge! settings.minimize.merge build_guard: true }

      it "builds configuration" do
        builder.call

        expect(configuration_path.read).to include(<<~CONTENT)
          guard :rspec, cmd: "NO_COVERAGE=true bin/rspec --format documentation" do
            require "guard/rspec/dsl"

            dsl = Guard::RSpec::Dsl.new self

            # Ruby
            ruby = dsl.ruby
            dsl.watch_spec_files_for ruby.lib_files

            # RSpec
            rspec = dsl.rspec
            watch rspec.spec_files

            # Hanami
            watch(rspec.spec_helper) { rspec.spec_dir }
            watch(%r(^spec/hanami_helper.rb$)) { rspec.spec_dir }
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build configuration" do
        builder.call
        expect(configuration_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
