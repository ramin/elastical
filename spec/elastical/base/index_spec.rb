require 'spec_helper'

describe Elastical::Base::Index do
  context '.in_batches' do
    before do
      model = mock_model('InspectahDeck')
      InspectahDeck
        .stub_chain(:find_in_batches)
        .and_yield([InspectahDeck.new])

      InspectahDeck.stub(:count).and_return(23)

      InspectahDeck.any_instance.stub(:to_document).and_return({_id: 42})
      InspectahDeck.any_instance.stub(:id).and_return(42)
      InspectahDeck.any_instance.stub(:appearances).and_return([])

      Stretcher::Index.any_instance.stub(:bulk_index)

      class WuTangAppearancesIndex < Elastical::Base
        indexes InspectahDeck do
          field :appearances
        end
      end

      WuTangAppearancesIndex
        .stub_chain(:discover_offset)
        .and_return(-> { 23 } )

      WuTangAppearancesIndex.stub(:exists?).and_return(true)
    end

    context 'creating mappings if index does not exist' do
      it 'should check index exists?' do
        WuTangAppearancesIndex.should_receive(:exists?).and_return(true)
        WuTangAppearancesIndex.should_not_receive(:create!)
        WuTangAppearancesIndex.in_batches
      end

      it 'call create! if index does not exist' do
        WuTangAppearancesIndex.should_receive(:exists?).and_return(false)
        WuTangAppearancesIndex.stub(:create!).and_return(true)
        WuTangAppearancesIndex.should_receive(:create!)
        WuTangAppearancesIndex.in_batches
      end
    end

    context 'async building the index' do
      it 'will lookup the scope for InspechtahDeck and count records' do
        WuTangAppearancesIndex
          .should_receive(:scope_for)
          .with(InspectahDeck)
          .and_return(-> { InspectahDeck } )

        InspectahDeck.should_receive(:count).once

        WuTangAppearancesIndex.async_in_batches
      end

      it 'expecting 23 records, batches in 5, should split indexing 5 times' do
        SearchIndexWorker
          .should_receive(:perform_async)
          .exactly(5)
          .times
        WuTangAppearancesIndex.async_in_batches(size: 5)
      end

      it 'expecting 120 records, batches in 50, should split indexing 3 times' do
        InspectahDeck.stub(:count).and_return(120)
        SearchIndexWorker
          .should_receive(:perform_async)
          .exactly(3)
          .times
        WuTangAppearancesIndex.async_in_batches(size: 50)
      end
    end

    context 'building the index' do
      it 'indexable_models should return Enummerable' do
        WuTangAppearancesIndex.indexable_models.should be_an_instance_of Enumerator
      end

      it 'will lookup the scope for InspechtahDeck' do
        WuTangAppearancesIndex
          .should_receive(:scope_for)
          .with(InspectahDeck)
          .and_return(-> { InspectahDeck } )
        WuTangAppearancesIndex.in_batches
      end

      it 'should call bulk' do
        WuTangAppearancesIndex
          .should_receive(:bulk)
        WuTangAppearancesIndex.in_batches
      end

      it 'should call bulk_index' do
        Stretcher::Index.any_instance.should_receive(:bulk_index)
        WuTangAppearancesIndex.in_batches
      end
    end

    context 'specifying an offset' do
      it 'should call bulk_index' do
        WuTangAppearancesIndex
          .should_receive(:discover_offset)
          .with(InspectahDeck, 1000)
          .and_return(-> { 23 } )

        WuTangAppearancesIndex.in_batches(offset: 1000)
      end
    end

    context 'indexing a single model' do
      it 'should get the document to send' do
        inspectah = InspectahDeck.new

        document = inspectah.to_document(:wu_tang_appearances)

        inspectah
          .should_receive(:to_document)
          .with(:wu_tang_appearances)
          .and_return(document)

        Stretcher::IndexType.any_instance.should_receive(:put).with(42, {})

        WuTangAppearancesIndex.put(inspectah)
      end

      it 'can call delete' do
        Stretcher::IndexType.any_instance.should_receive(:delete).with("inspectah_deck-42")
        WuTangAppearancesIndex.delete(InspectahDeck.new)
      end
    end
  end
end
