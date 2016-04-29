module Overcover

  class GitReporter

    class << self

      def on_hook(sample = false)
        # find files changed in the last 5 days
        git_log = `git log --pretty="format:" -1 --name-only`
        files = git_log.split("\n")
        files.uniq!

        # check they still exist
        files.reject! { |f| !File.exists?(f) }
        files.reject! { |f| f.empty? }

        files.map! { |f| './' + f }

        changed_specs = files.select { |f| f =~ /_spec.rb/ }

        # filter out the ones that we actually care about
        touched_files = files.select { |f| Overcover::RspecCollector.should_analyse?(f) }

        reporter = Overcover::Reporter.new
        specs = []
        touched_files.each do |f|
          covering = reporter.specs_for(f)
          if covering.nil?
            $stderr.puts "WARNING: No specs have been recorded covering #{f}"
          end
          if sample
            specs << covering.shuffle.take(3) unless covering.nil?
          else
            specs << covering
          end
        end
        specs = specs.flatten.uniq

        on_hook = (specs + changed_specs).flatten.uniq

        $stderr.puts "Sampling: this will choose 3 specs for each changed file"
        $stderr.puts "Changed files: #{files.count}"
        $stderr.puts "    changed specs: #{changed_specs.count}"
        $stderr.puts "    changed files: #{touched_files.count}"
        $stderr.puts "    covered by: #{specs.count} specs"
        $stderr.puts "    will run: #{on_hook.count} specs"

        on_hook.each do |f|
          puts f
        end

      end

    end

  end

end