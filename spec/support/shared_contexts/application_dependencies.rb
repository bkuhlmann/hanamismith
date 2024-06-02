# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  using Refinements::Struct

  include_context "with temporary directory"

  let(:settings) { Hanamismith::Container[:settings] }
  let(:xdg_config) { Runcom::Config.new Hanamismith::Container[:defaults_path] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: :hanamismith, io: StringIO.new, level: :debug }

  before do
    settings.merge! Etcher.call(
      Hanamismith::Container[:registry].remove_loader(1),
      author_family_name: "Smith",
      author_given_name: "Jill",
      project_name: "test",
      target_root: temp_dir
    )

    Hanamismith::Container.stub! xdg_config:, kernel:, logger:
  end

  after { Hanamismith::Container.restore }
end
