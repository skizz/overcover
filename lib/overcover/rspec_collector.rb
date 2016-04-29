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

      def set_log_file(filename)
        @log_file = filename
      end

      def add_filter(filter)
        paths << filter
      end

      def log_file
        @log_file ||= 'overcover.log'
      end

      def reset
        File.delete(log_file) if File.exists?(log_file)
      end

      def record(result)
        open(log_file, 'a') do |f|
          f.puts Psych.dump(result)
        end
      end

      def start

        @log_file = 'overcover.log'

        yield self if block_given?

        collector = CoverageCollector.new(self)
        root_path = Dir.pwd.to_s

        RSpec.configure do |config|
          # overcover
          config.before(:each) do |example|
            file = example.file_path.sub(root_path, ".")
            collector.before(file)
          end

          config.after(:each) do |example|
            file = example.file_path.sub(root_path, ".")
            collector.after(file)
          end
        end

      end

    end

  end

end
