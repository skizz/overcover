require 'spec_helper'

describe Overcover::RspecCollector do

  it 'can be started multiple times' do
    Overcover::RspecCollector.start
    Overcover::RspecCollector.start
    Overcover::RspecCollector.start
  end

  it 'records all files by default' do
    expect(Overcover::RspecCollector.should_analyse?("foo/bar")).to be_truthy
    expect(Overcover::RspecCollector.should_analyse?("foo/baz")).to be_truthy
    expect(Overcover::RspecCollector.should_analyse?("foo/quux")).to be_truthy
  end

  it 'only counts filtered files if any filters are set' do
    Overcover::RspecCollector.start do |config|
      config.add_filter 'lib/'
    end
    expect(Overcover::RspecCollector.should_analyse?("foo/bar")).to be_falsey
    expect(Overcover::RspecCollector.should_analyse?("lib/foo/bar")).to be_truthy
  end

end