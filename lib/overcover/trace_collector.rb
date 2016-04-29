# Collect coverage information using Trace
class TraceCollector

  def initialize(context)
    @context = context
  end

  def trace
    if @trace.nil?
      @trace = TracePoint.new(:line) do |tp|
        path = tp.path.sub(root_path, ".")
        record(path) if @context.should_analyse?(path)
      end
    end
    @trace
  end

  def before(example)
    @in_spec = example
    @files = Set.new
    trace.enable
  end

  def after(example)
    trace.disable
    result = { spec: @in_spec, files: @files.to_a }
    @context.record(result)
    @files = nil
    @in_spec = nil
  end

  def root_path
    Dir.pwd.to_s
  end

  def record(path)
    @files << path if @files
  end

end

