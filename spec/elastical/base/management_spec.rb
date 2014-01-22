require 'spec_helper'

describe Elastical::Base::Management do
  context 'management' do
    before do
      class TestManagementIndex < Elastical::Base
      end
    end

    it 'should refresh' do
      Stretcher::Index.any_instance.stub(:refresh).and_return(true)
      Stretcher::Index.any_instance.should_receive(:refresh).once

      TestManagementIndex.respond_to?(:refresh!).should == true
      TestManagementIndex.refresh!
    end

    context 'create and delete' do
      before do
        Stretcher::Index.any_instance.stub(:create).and_return(true)
        Stretcher::Index.any_instance.stub(:delete).and_return(true)
      end

      it 'should create' do
        Stretcher::Index.any_instance.should_receive(:create).once

        TestManagementIndex.respond_to?(:create!).should == true
        TestManagementIndex.create!
      end

      it 'should delete' do
        Stretcher::Index.any_instance.should_receive(:delete).once

        TestManagementIndex.respond_to?(:delete!).should == true
        TestManagementIndex.delete!
      end

      it 'should recreate and check existence' do
        Stretcher::Index.any_instance.should_receive(:create).once
        Stretcher::Index.any_instance.should_receive(:delete).once
        TestManagementIndex.stub(:exists?).and_return(true)

        TestManagementIndex.respond_to?(:recreate!).should == true
        TestManagementIndex.recreate!
      end

      it 'should call recreate, but not call delete! because it doesnt exist' do
        Stretcher::Index.any_instance.should_receive(:create).once
        Stretcher::Index.any_instance.should_not_receive(:delete)
        TestManagementIndex.stub(:exists?).and_return(false)
        TestManagementIndex.recreate!
      end
    end

    it 'should test existence' do
      Stretcher::Index.any_instance.stub(:exists?).and_return(true)
      Stretcher::Index.any_instance.should_receive(:exists?).once
      TestManagementIndex.respond_to?(:exists?).should == true
      TestManagementIndex.exists?
    end
  end
end
