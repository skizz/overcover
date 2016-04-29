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

      def log_file(filename)
        @log_file = filename
      end

      def add_filter(filter)
        paths << filter
      end

      def start

        @log_file = 'overcover.log'

        yield self if block_given?

        RSpec.configure do |config|
          # overcover
          config.before(:example) do |example|
            Overcover::RspecCollector.before(example)
          end

          config.after(:example) do |example|
            Overcover::RspecCollector.after(example)
          end
        end

      end

      def trace
        if @trace.nil?
          @trace = TracePoint.new(:line) do |tp|
            path = tp.path.sub(root_path, ".")
            record path if should_analyse? path
          end
        end
        @trace
      end

      def root_path
        Dir.pwd.to_s
      end

      def before(example)
        @in_spec = example.file_path.sub(root_path, ".")
        @files = Set.new
        trace.enable
      end

      def record(path)
        @files << path if @files
      end

      def after(example)
        trace.disable
        result = { spec: @in_spec, files: @files.to_a }
        open(@log_file, 'a') do |f|
          f.puts Psych.dump(result)
        end
        @files = nil
        @in_spec = nil
      end

    end

  end

end
