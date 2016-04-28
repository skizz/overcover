require 'psych'

module Overcover

  class RspecCollector

    class << self

      def paths
        ['./app/', './lib/', './config/']
      end

      def should_analyse?(path)
        paths.any? {|p| path.start_with?(p) }
      end

      def start
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
            path = tp.path.sub(Rails.root.to_s, ".")
            record path if should_analyse? path
          end
        end
        @trace
      end

      def before(example)
        @in_spec = example.file_path.sub(Rails.root.to_s, ".")
        @files = Set.new
        trace.enable
      end

      def record(path)
        @files << path if @files
      end

      def after(example)
        trace.disable
        result = { spec: @in_spec, files: @files.to_a }
        open('overcover.log', 'a') do |f|
          f.puts YAML.dump(result)
        end
        @files = nil
        @in_spec = nil
      end

    end

  end

end
