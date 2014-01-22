require 'spec_helper'

describe Elastical::Indexes do
  before do
    Elastical::Indexes.empty!
  end

  after :each do
    Elastical::Indexes.empty!
  end

  it 'should allow pushing into set' do
	Elastical::Indexes << :wu_tang_forever
    Elastical::Indexes.all.should == [:wu_tang_forever]
  end

  it 'should act as a set' do
	Elastical::Indexes << :wu_tang_forever
	Elastical::Indexes << :wu_tang_forever
    Elastical::Indexes << :return_to_the_36_chambers
    Elastical::Indexes.all.should == [:wu_tang_forever, :return_to_the_36_chambers]
  end

  it 'should symbolize entry' do
	Elastical::Indexes << "the_w"
    Elastical::Indexes.all.should == [:the_w]
  end

  it 'should know if something exists' do
	Elastical::Indexes << :wu_tang_forever
    Elastical::Indexes.exists?(:wu_tang_forever)
    Elastical::Indexes.exists?(:return_to_the_36_chambers)
  end
end
