require 'psych'
require 'set'

module Overcover

  class RspecCollector

    class << self

      def paths
        @paths ||= []
      end

      def should_analyse?(path)
        paths.empty? || paths.any? {|p| path.start_with?(p) }
      end

      def add_filter(filter)
        paths << filter
      end

      def reset
        puts "[overcover] deleting log files in #{dir}"
        log_files.each do |f|
          File.delete(f)
        end
      end

      def record(result)
        open(@log_file, 'a') do |f|
          f.puts Psych.dump(result)
        end
      end

      def dir
        ENV["OVERCOVER_DIR"] || "."
      end

      def log_files
        files = Dir.glob(File.join(dir, "overcover.*.tmp"))
        if block_given?
          files.each do |f|
            yield f
          end
        end
        files
      end

      def log_file
        @log_file
      end

      def start

        @log_file = File.join(dir ,"overcover.#{Time.now.utc.strftime("%Y%m%d%H%M%S%N")}.tmp")

        yield self if block_given?

        puts "[overcover] writing to log file #{@log_file}"

        if CoverageCollector.supported?
          collector = CoverageCollector.new(self)
        else
          puts "[overcover] WARNING: Using the slow TraceCollector since this version of ruby"
          puts "[overcover] does not support Coverage.peek_result. Use MRI 2.3+ for faster results."
          collector = TraceCollector.new(self)
        end
        root_path = Dir.pwd.to_s

        RSpec.configure do |config|
          # overcover
          config.before(:example) do |example|
            # puts "BEFORE #{example} #{example.location}"
            # puts "puts pid=#{Process.pid}"
            file = example.file_path.sub(root_path, ".")
            collector.before(file)
          end

          config.after(:example) do |example|
            # puts "AFTER #{example} #{example.location}"
            # puts "puts pid=#{Process.pid}"
            file = example.file_path.sub(root_path, ".")
            collector.after(file)
          end

          config.after(:suite) do |suite|
            Overcover::Reporter.summarize
          end

        end

      end

    end

  end

end
