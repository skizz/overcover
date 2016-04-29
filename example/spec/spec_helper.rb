$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'overcover'
Overcover::RspecCollector.start do |c|
  c.reset
  c.add_filter './lib/'
end

require 'sample'

RSpec.configure do |config|
  # config.before(:each) do |suite|
  #   puts "BEFORE: #{suite.file_path}"
  # end
  # config.after(:each) do |suite|
  #   puts "AFTER: #{suite.file_path}"
  # end
  config.after(:suite) do |suite|
    Overcover::Reporter.summarize
  end
end
