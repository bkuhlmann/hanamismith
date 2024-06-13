# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  using Refinements::Struct

  include_context "with temporary directory"

  let(:settings) { Hanamismith::Container[:settings] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: :hanamismith, io: StringIO.new, level: :debug }

  before do
    settings.merge! Etcher.call(
      Hanamismith::Container[:registry].remove_loader(1),
      author_family_name: "Smith",
      author_given_name: "Jill",
      author_email: "jill@acme.io",
      loaded_at: Time.utc(2020, 1, 1, 0, 0, 0),
      target_root: temp_dir,
      project_name: "test"
    )

    Hanamismith::Container.stub! kernel:, logger:
  end

  after { Hanamismith::Container.restore }
end
