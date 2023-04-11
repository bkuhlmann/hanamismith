# frozen_string_literal: true

require "dry/container/stub"
require "infusible/stub"

RSpec.shared_context "with application dependencies" do
  using Refinements::Structs
  using Infusible::Stub

  include_context "with temporary directory"

  let :configuration do
    Hanamismith::Configuration::Loader.with_overrides.call.merge(
      now: Time.local(2020, 1, 1, 0, 0, 0),
      project_name: "test",
      target_root: temp_dir
    )
  end

  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new io: StringIO.new, formatter: :emoji }

  before { Hanamismith::Import.stub configuration:, kernel:, logger: }

  after { Hanamismith::Import.unstub :configuration, :kernel, :logger }
end
