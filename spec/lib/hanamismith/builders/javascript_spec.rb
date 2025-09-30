# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::Javascript do
  using Refinements::Struct

  subject(:builder) { described_class.new settings:, logger: }

  include_context "with application"

  describe "#call" do
    it "builds file" do
      builder.call

      expect(temp_dir.join("test/app/assets/js/app.js").read).to eq(<<~CONTENT)
        import "../css/settings.css";
        import "../css/colors.css";
        import "../css/view_transitions.css";
        import "../css/defaults.css";
        import "../css/layout.css";

        import htmx from "htmx.org";
        window.htmx = htmx;
      CONTENT
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
