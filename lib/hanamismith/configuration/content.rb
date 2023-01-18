# frozen_string_literal: true

module Hanamismith
  module Configuration
    # Defines the content of the configuration for use throughout the gem.
    Content = Struct.new(
      :action_config,
      :action_help,
      :action_version,
      keyword_init: true
    ) do
      def initialize *arguments
        super
        freeze
      end
    end
  end
end
