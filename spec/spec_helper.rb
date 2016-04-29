$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'overcover'
Dir.mkdir('tmp') unless Dir.exists?('tmp')
# Overcover::RspecCollector.start do |config|
#   config.set_log_file 'tmp/self_test.log'
#   config.add_filter 'lib/'
# end
# RSpec.configure do |config|
#   config.after(:suite) do
#     Overcover::Reporter.summarize
#   end
# end

# RSpec.configure do |config|
#   config.before(:each) do |suite|
#     puts "BEFORE: #{suite.file_path}"
#   end
#   config.after(:each) do |suite|
#     puts "AFTER: #{suite.file_path}"
#   end
# end