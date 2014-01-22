require 'spec_helper'

describe Elastical::Base::Remote do
  context 'remote' do
    before do
      class TestRemoteIndex < Elastical::Base
      end

      Stretcher::Index.any_instance.stub(:get_settings).and_return(true)
      Stretcher::Index.any_instance.stub(:status).and_return(true)
      Stretcher::Index.any_instance.stub(:stats).and_return(true)
      Stretcher::Index.any_instance.stub(:get_mapping).and_return(true)
    end


    it 'should allow call to settings' do
      Stretcher::Index.any_instance.should_receive(:get_settings).once
      TestRemoteIndex.respond_to?(:settings).should == true
      TestRemoteIndex.settings
    end

    it 'should allow call to status' do
      Stretcher::Index.any_instance.should_receive(:status).once
      TestRemoteIndex.respond_to?(:status).should == true
      TestRemoteIndex.status
    end

    it 'should allow call to stats' do
      Stretcher::Index.any_instance.should_receive(:stats).once
      TestRemoteIndex.respond_to?(:stats).should == true
      TestRemoteIndex.stats
    end

    it 'should allow call to mappings' do
      Stretcher::Index.any_instance.should_receive(:get_mapping).once
      TestRemoteIndex.respond_to?(:remote_mappings).should == true
      TestRemoteIndex.remote_mappings
    end
  end
end
