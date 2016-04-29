# Collect coverage information using ruby's built in Coverage
require 'coverage'

module Overcover

  class CoverageCollector

    def initialize(context)
      @context = context
      @counts = {}
      Coverage.start unless @started
      @started = true
    end

    def before(example)
      @in_spec = example
      # puts "Calling Coverage.start"
      # Coverage.start unless @started
      # @started = true
    end

    def after(example)
      return unless @started

      coverage = Coverage.peek_result
      # @started = false

      files = []
      coverage.each_pair do |file, line_counts|
        path = file.sub(root_path, ".")
        if @context.should_analyse?(path)
          count = @counts[path] || 0
          new_count = line_counts.inject(0) {|sum, val| val.nil? ? sum : sum+val }
          if new_count > count
            # puts "    #{new_count - count} #{path}"
            files << path
          end
          @counts[path] = new_count
        end
      end
      result = { spec: @in_spec, files: files }
      @context.record(result)

      @in_spec = nil
    end

    def root_path
      Dir.pwd.to_s
    end

  end

end


