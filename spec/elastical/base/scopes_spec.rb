require 'spec_helper'

describe Elastical::Base::Models do
  before do
    class WuTang2013Index < Elastical::Base
      # Need ar here sorry
      indexes Post.live do
        field :title_without_tags, as: :title do |post|
          post.title_without_tags.reverse
        end
      end
    end
  end

  let(:live_post)   { FactoryGirl.create(:post, status_code: 2) }
  let(:queued_post) { FactoryGirl.create(:post, status_code: 4) }

  context 'testing scope' do
    it 'knows that a record is within index scope' do
      WuTang2013Index.within_scope?(live_post).should == true
    end

    it 'knows that a record is within index scope' do
      WuTang2013Index.within_scope?(queued_post).should == false
    end
  end

  it 'stores the scope for query' do
    WuTang2013Index.scopes.keys.should == [Post]
  end

  it 'should be able to call the scope' do
    WuTang2013Index.scope_for(Post).lambda?.should == true
  end
end
