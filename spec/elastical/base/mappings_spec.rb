require 'spec_helper'

describe Elastical::Base::Mappings do
  before do
    model = mock_model('Ghostface')
    Ghostface.any_instance.stub(
      albums: ["supreme clientele", "fishscale", "ironman"],
      mustache: "milk on, down to my chinny chin",
      age: 33,
      )

    class WuTangForeverIndex < Elastical::Base
      indexes Ghostface do
        field :albums, type: :array,  store: true
        field :mustache, type: :string, index: 'no'
        field :age, type: :integer
      end
    end
  end

  it 'should have mappings' do
	WuTangForeverIndex.mappings.should == {
      ghostface: {
        properties: {
          albums:   { type: :array, store: true },
          mustache: { type: :string, index: 'no' },
          age:      { type: :integer }
        }
      }
    }
  end
end
