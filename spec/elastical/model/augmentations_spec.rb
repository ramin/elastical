require 'spec_helper'

describe Elastical::Model::Augmentations do
  context 'when included in a model' do
    before do
      class TestAugmentations
        include Elastical::Model::Augmentations
      end
    end

    it 'should add an elastical? class level method' do
      TestAugmentations.respond_to?(:elastical?).should == true
      TestAugmentations.elastical?.should == true
    end

    it 'adds mappings and documents hashes' do
      TestAugmentations.mappings.should == {}
      TestAugmentations.documents.should == {}
    end

    it 'returns indexes as an array' do
      TestAugmentations.indexes.should == []
    end

    context 'then calling indexed_by' do
      before do
        @some_model  = mock_model('SomeModel')
        SomeModel.any_instance.stub(:foo).and_return("welp")
        SomeModel.any_instance.stub(:id).and_return(23)

        class WhateverIndex < Elastical::Base
          indexes SomeModel do
            field :foo, type: :string, index: 'no'
            field :nomap do |cat|
              :killah_bees
            end
          end
        end
      end

      it 'adds :whatever to mapping hash' do
        SomeModel.mappings.should be_an_instance_of Hash
        SomeModel.mapping(:whatever).should be_an_instance_of Hash
        SomeModel.whatever_mapping.should be_an_instance_of Hash
        WhateverIndex.mappings[:some_model][:properties][:foo].should == SomeModel.mapping(:whatever)[:foo]
      end

      it 'does not add :nomap to mapping hash' do
        SomeModel.mappings.should be_an_instance_of Hash
        SomeModel.mapping(:nomap).should == {}
        WhateverIndex.mappings[:some_model][:properties][:nomap].should == nil
      end

      it 'adds a dynamic <index>_mapping method' do
        mapping_by_key = SomeModel.mapping(:whatever)
        SomeModel.whatever_mapping.should == mapping_by_key
      end

      it 'should add a document to the model instance' do
        SomeModel.new.respond_to?(:to_document).should be_true
        SomeModel.new.to_document(:whatever).should == { _id: "some_model-23", foo: 'welp', nomap: :killah_bees }
      end

      it 'should add a <index>_document to the model instance' do
        SomeModel.new.respond_to?(:whatever_document).should be_true
        SomeModel.new.whatever_document.should == { _id: "some_model-23", foo: 'welp', nomap: :killah_bees }
      end
    end
  end
end
