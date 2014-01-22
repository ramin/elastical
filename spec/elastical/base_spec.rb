require 'spec_helper'

describe Elastical::Base do
  context 'index names' do
    before do
      class TestIndex < Elastical::Base
      end
    end

    it 'should prepare a name to prepend magic methods' do
      TestIndex.inferred_index_name.should == :test
    end

    context 'manual names' do
      class IndexWithOtherName < Elastical::Base
        named "whatever"
      end

      it 'should support manually setting the index name and convert to sym' do
        IndexWithOtherName.inferred_index_name.should == :whatever
        IndexWithOtherName.inferred_index_name.should be_an_instance_of Symbol
      end
    end
  end

  context 'model aliases' do
    before do
      mock_model('Raekwon')
      mock_model('RaekwonTheChef')
    end

    it 'can get a name using klass if no as option present' do
      Elastical::Base.alias_model(Raekwon, {}).should == :raekwon
    end

    it 'will underscore and symbolize a passed in constant' do
      Elastical::Base.alias_model(RaekwonTheChef, {}).should == :raekwon_the_chef
    end

    it 'will use options[:as] as an alias and symbolize' do
      Elastical::Base.alias_model(RaekwonTheChef, {as: "shallah_raekwon"}).should == :shallah_raekwon
    end
  end
end
