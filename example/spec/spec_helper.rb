$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'overcover'
Overcover::RspecCollector.start do |c|
  c.reset
  c.add_filter './lib/'
end

require 'sample'

