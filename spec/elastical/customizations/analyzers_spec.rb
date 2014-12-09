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

  context 'phraser' do
    it 'defines the defined phraser' do
      key = subject[:analysis][:analyzer]
      expect(key[:phraser]).to eq(Elastical::Customizations::Analyzers.new.phraser)
    end

    it 'defines the defined filter' do
      key = subject[:analysis][:filter]
      expect(key[:custom_shingle]).to eq(Elastical::Customizations::Analyzers.new.custom_shingle)
    end

    it 'includes the filter definition' do
      expect(subject[:analysis][:filter]).to_not eq(nil)
      expect(subject[:analysis][:filter]).to be_an_instance_of(Hash)
    end
  end

  context 'synonyms' do
    it 'defines the synonym analyzer' do
      key = subject[:analysis][:analyzer]
      expect(key[:synonym]).to eq(Elastical::Customizations::Analyzers.new.synonyms)
    end

    it 'defines the synonym filter' do
      key = subject[:analysis][:filter]
      expect(key[:synonym]).to eq(Elastical::Customizations::Analyzers.new.synonym_filter)
    end

    it 'filters with lowercase stop and synonym' do
      key = subject[:analysis][:analyzer][:synonym]
      expect(key[:filter]).to eq(["snowball", "lowercase", "stop", "synonym"])
    end

    it 'expects a file at analysis/snonyms-strict.txt' do
      key = subject[:analysis][:filter]
      expect(key[:synonym][:synonyms_path]).to eq("analysis/synonyms.txt")
    end
  end

  context 'text' do
    it 'defines the synonym analyzer' do
      key = subject[:analysis][:analyzer]
      expect(key[:text]).to eq(Elastical::Customizations::Analyzers.new.text)
    end

    it 'defines snowball, lowercase, stop, asciifoldering for analyzer' do
      key = subject[:analysis][:analyzer]
      expect(key[:text][:filter]).to eq(["snowball", "lowercase", "stop", "asciifolding"])
    end
  end
end
