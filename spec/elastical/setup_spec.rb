require 'spec_helper'

describe Elastical::Setup do
  context 'initialization' do
    it 'should respond to block' do
      Elastical::Setup.initialize do |config|
        config.should be_an_instance_of Elastical::Config
      end
    end

    it 'should return an instance of Elastical::Config' do
      Elastical::Setup.initialize.should be_an_instance_of Elastical::Config
    end
  end
end
