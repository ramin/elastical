require 'spec_helper'

describe Elastical::Base::Models do
  before do
    model = mock_model('RZA')
    RZA.any_instance.stub(beats: :phat)

    class WuTangIndex < Elastical::Base
      indexes RZA, as: :producer do
        field :beats
      end
    end
  end

  it 'should return models with mapping/alias' do
	WuTangIndex.models.should == { producer: RZA }
  end

  it 'can return a list of known aliases' do
    WuTangIndex.aliases.should == [:producer]
  end

  it 'should be able to map an alias to class' do
    WuTangIndex.alias_of(:producer).should == RZA
  end

  it 'should be able to map a class to its alias' do
    WuTangIndex.alias_for(RZA).should == :producer
  end

  it 'can return an array of classes' do
	WuTangIndex.classes == [RZA]
  end
end
