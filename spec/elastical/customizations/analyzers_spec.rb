require 'spec_helper'

describe Elastical::Customizations::Analyzers do
  subject{ Elastical::Customizations::Analyzers.new.all }

  it 'returns a configuration hash' do
	expect(subject[:analysis]).to be_an_instance_of(Hash)
  end

  it 'includes the analysis key' do
	expect(subject[:analysis]).to_not eq(nil)
	expect(subject[:analysis]).to be_an_instance_of(Hash)
  end

  it 'includes the phraser analyzer definition' do
    key = subject[:analysis][:analyzer]
	expect(key).to_not eq(nil)
	expect(key).to be_an_instance_of(Hash)
    expect(key.keys.include?(:phraser)).to eq(true)
  end

  it 'spits out the defined phraser' do
    key = subject[:analysis][:analyzer]
    expect(key[:phraser]).to eq(Elastical::Customizations::Analyzers.new.phraser)
  end

  it 'spits out the defined filter' do
    key = subject[:analysis][:filter]
    expect(key[:custom_shingle]).to eq(Elastical::Customizations::Analyzers.new.custom_shingle)
  end

  it 'includes the filter definition' do
	expect(subject[:analysis][:filter]).to_not eq(nil)
	expect(subject[:analysis][:filter]).to be_an_instance_of(Hash)
  end
end
