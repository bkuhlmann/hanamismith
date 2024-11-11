# frozen_string_literal: true

module Hanamismith
  module Builders
    module Git
      # Builds project skeleton initial Git commit message.
      class Commit < Rubysmith::Builders::Git::Commit
        include Dependencies[:specification]
      end
    end
  end
end
