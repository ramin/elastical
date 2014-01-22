require 'spec_helper'

describe Elastical::Model::Callbacks do
  context 'when included in a model' do
    before do
      class TestCallbacks
        include Elastical::Model::Callbacks
      end
    end

    it 'should add a save_and_update_index method' do
      TestCallbacks.new.respond_to?(:save_and_update_index).should == true
    end

    it 'adds an elastical_update! method' do
      TestCallbacks.new.respond_to?(:elastical_update!).should == true
    end

    it 'adds an elastical_remove! method' do
      TestCallbacks.new.respond_to?(:elastical_remove!).should == true
    end
  end

  context 'when a model is indexed' do
    before do
      method_man = mock_model('MethodMan')
      MethodMan.any_instance.stub(:test)
      MethodMan.any_instance.stub(:id).and_return(42)

      class MethodManIndex < Elastical::Base
        indexes MethodMan do
          field :test
        end
      end

      MethodManIndex
        .stub_chain(:within_scope?)
        .and_return(true)
    end

    it 'yields the indexes from target_indexes' do
      expect { |test| MethodMan.new.send(:target_indexes, &test) }
        .to yield_with_args(MethodManIndex)
    end

    it 'should save and update elastical if saved' do
      MethodMan.any_instance.stub(:save).and_return(true)
      MethodMan.any_instance.should_receive(:elastical_update!).once
      MethodMan.new.save_and_update_index
    end

    it 'should save and update elastical if saved' do
      MethodMan.any_instance.stub(:save).and_return(false)
      MethodMan.any_instance.should_not_receive(:elastical_update!)
      MethodMan.new.save_and_update_index
    end

    context 'saving and deleting' do
      it 'elastical_update!' do
        method_man = MethodMan.new
        MethodManIndex.should_receive(:put).with(method_man)
        method_man.elastical_update!
      end

      it 'elastical_remove!' do
        method_man = MethodMan.new
        MethodManIndex.should_receive(:delete).with(method_man)
        method_man.elastical_remove!
      end
    end
  end
end
