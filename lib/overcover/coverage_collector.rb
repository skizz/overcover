# Collect coverage information using ruby's built in Coverage
require 'coverage'

module Overcover

  class CoverageCollector

    def initialize(context)
      @context = context
      Coverage.start unless @started
    end

    def before(example)
      # puts "BEFORE #{example}"
      @in_spec = example
      Coverage.start unless @started
      @started = true
    end

    def after(example)
      # puts "AFTER #{example}"
      coverage = Coverage.result
      # p coverage
      paths = coverage.keys.map { |f| f.sub(root_path, ".") }
      files = paths.select { |path| @context.should_analyse?(path) }
      result = { spec: @in_spec, files: files }
      @context.record(result)
      @in_spec = nil
    ensure
      @started = false
    end

    def root_path
      Dir.pwd.to_s
    end

  end

end


