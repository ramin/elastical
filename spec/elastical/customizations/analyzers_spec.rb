require 'spec_helper'

describe Elastical::Customizations::Analyzers do
  it 'returns a configuration hash' do
	expect(subject[:analysis]).to be_an_instance_of(Hash)
  end

  it 'includes the analysis key' do
	expect(subject[:analysis]).to_not eq(nil)
	expect(subject[:analysis]).to be_an_instance_of(Hash)
  end

  it 'includes the phraser analyzer definition' do
	expect(subject[:analysis][:analyzer]).to_not eq(nil)
	expect(subject[:analysis][:analyzer]).to be_an_instance_of(Hash)
  end

  it 'includes the filter definition' do
	expect(subject[:analysis][:filter]).to_not eq(nil)
	expect(subject[:analysis][:filter]).to be_an_instance_of(Hash)
  end
end
