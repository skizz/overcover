module Overcover

  class GitReporter

    class << self

      def on_hook
        # find files changed in the last 5 days
        git_log = `git log --pretty="format:" --since="5 days ago" --name-only`
        files = git_log.split("\n")
        files.uniq!

        # check they still exist
        files.reject! { |f| !File.exists?(f) }

        p files
      end

    end

  end

end