# frozen_string_literal: true

RSpec.shared_context "with application dependencies" do
  include_context "with temporary directory"

  let :configuration do
    Etcher.new(Hanamismith::Container[:defaults])
          .call(
            author_family_name: "Smith",
            author_given_name: "Jill",
            project_name: "test",
            target_root: temp_dir
          )
          .bind(&:dup)
  end

  let(:input) { configuration.dup }
  let(:xdg_config) { Runcom::Config.new Hanamismith::Container[:defaults_path] }
  let(:kernel) { class_spy Kernel }
  let(:logger) { Cogger.new id: :hanamismith, io: StringIO.new, level: :debug }

  before { Hanamismith::Container.stub! configuration:, input:, xdg_config:, kernel:, logger: }

  after { Hanamismith::Container.restore }
end
