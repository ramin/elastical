require 'spec_helper'

describe Elastical::Mapping do
  context 'defaults' do
    it 'should strip non allowed fields' do
      options = {
        cash: :rules,
        type: :string,
        everything: :around,
        boost: 1.2,
        me: :cream,
        analyzer: :snowball,
        get: :money,
        index: false,
        dollar: :dollar,
        store: true,
        bills: :yall
      }

      cleaned = Elastical::Mapping.options_to_mapping_with_defaults(options)
      cleaned.should == {
        type: :string,
        boost: 1.2,
        analyzer: :snowball,
        index: false,
        store: true
      }
    end

    it 'should return an empty hash if no options are given' do
      options = {}
      Elastical::Mapping.options_to_mapping_with_defaults(options).should == {}
    end

    it 'should return merge required mapping fields if any options are provided' do
      options = {as: :killah_beez, index: true}
      Elastical::Mapping.options_to_mapping_with_defaults(options).should == {type: :string, index: true}
    end
  end
end
