# frozen_string_literal: true

module Hanamismith
  module Extensions
    # Ensures assets are compiled.
    class Asset
      include Dependencies[:settings, :kernel, :logger]

      def call
        logger.error { "Unable to compile assets. Try: `hanami assets compile`." } unless compile
        true
      end

      private

      def compile
        kernel.system "node config/assets.js -- --path=app --dest=public/assets > /dev/null 2>&1",
                      chdir: settings.project_root
      end
    end
  end
end
