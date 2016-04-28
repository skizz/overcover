require 'psych'

module Overcover

  class Reporter

    def initialize()
      analyse
    end

    def specs
      @specs || analyse
    end

    def reverse
      @reverse || load_reverse
    end

    def load_reverse
      @reverse = {}
      specs.each_pair do |spec, covers|
        covers.each do |cover|
          @reverse[cover] ||= []
          @reverse[cover]<< spec
        end
      end
      @reverse
    end

    def analyse
      @specs = {}
      return unless File.exists?(Overcover::RspecCollector.log_file)
      Psych.load_stream(File.read(Overcover::RspecCollector.log_file)) do |hash|
        spec_file = hash[:spec]
        covers = @specs[spec_file] || []
        covers << hash[:files]
        @specs[spec_file] = covers.flatten.uniq
      end
      @specs
    end

    def summarize
      spec_report = specs.map { |file, covers|  { file: file, count: covers.count } }
      spec_report.sort! { |a, b| a[:count] <=> b[:count] }
      spec_report.reverse!

      file_report = reverse.map { |cover, specs|  { cover: cover, count: specs.count } }
      file_report.sort! { |a, b| a[:count] <=> b[:count] }
      file_report.reverse!

      puts

      puts "Overcover report"
      puts "    #{spec_report.count} specs analysed"
      puts "    #{file_report.count} files analysed"

      puts "Specs covering the most files:"
      spec_report.take(10).each do |f|
        puts "    #{f[:file]} #{f[:count]} "
      end

      puts "Files covered by the most specs:"
      file_report.take(10).each do |f|
        puts "    #{f[:cover]} #{f[:count]} "
      end


    end

    def analyse_spec(f)
      puts "Overcover report"
      puts "Spec file: #{f}"
      specs[f].each do |cover|
        puts "    #{cover}"
      end
    end

    def analyse_file(f)
      puts "Overcover report"
      puts "Production file: #{f}"
      reverse[f].each do |cover|
        puts "    #{cover}"
      end
    end

    def specs_for(f)
      reverse[f]
    end

    class << self

      def summarize
        Overcover::Reporter.new.summarize
      end

      def analyse_spec(f)
        Overcover::Reporter.new.analyse_spec(f)
      end

      def analyse_file(f)
        Overcover::Reporter.new.analyse_file(f)
      end
    end

  end

end
