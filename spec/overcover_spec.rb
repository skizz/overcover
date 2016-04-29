require 'spec_helper'

describe Overcover do
  it 'has a version number' do
    expect(Overcover::VERSION).not_to be nil
  end

  context 'starting' do

    it 'can be started multiple times' do
      5.times { Overcover::RspecCollector.start }
    end

    it 'supports setting a log file' do
      file_name = "tmp/my_log_file.log"
      File.delete(file_name) if File.exists?(file_name)
      Overcover::RspecCollector.start do |config|
        Dir.mkdir('tmp') unless Dir.exists?('tmp')
        config.log_file "tmp/my_log_file.log"
      end
      expect(File.exists?(file_name))
    end

  end

end
