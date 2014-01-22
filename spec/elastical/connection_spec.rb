require 'spec_helper'

describe Elastical::Connection do
  context 'single hosts' do
    before :each do
      Elastical::Config.stub(:host).and_return("http://statenisland:9200")
    end

    it 'respresents clients as an array always' do
      Elastical::Connection.instance.clients.should be_instance_of(Array)
    end

    it 'have 1 host' do
      Elastical::Connection.instance.clients.size.should == 1
    end

    it 'returns a single client' do
      Elastical::Connection.instance.client.should be_instance_of(Stretcher::Server)
    end
  end

  context 'multiple hosts' do
    let(:hosts) { ["http://statenisland:9200", "http://brooklynzoo:9200"]   }
    before :each do
      Elastical::Config.stub(:host).and_return(hosts)
      Elastical::Connection.reset!
    end

    it 'respresents clients as an array' do
      Elastical::Connection.instance.clients.should be_instance_of(Array)
    end

    it 'has two hosts' do
      Elastical::Connection.instance.clients.size.should == 2
    end

    it 'returns a single client' do
      Elastical::Connection.instance.client.should be_instance_of(Stretcher::Server)
    end
  end
end
