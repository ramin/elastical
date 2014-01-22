require 'spec_helper'

describe Elastical::Config do
  it 'should respond class level host' do
    Elastical::Config.respond_to?(:host).should == true
  end

  it 'should respond to host' do
    Elastical::Config.instance.respond_to?(:host).should == true
  end
end
