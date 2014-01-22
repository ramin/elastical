module Elastical
  class Base
    module Indexing
      extend ActiveSupport::Concern

      INDEX_BATCH_DEFAULT = 100

      module ClassMethods
        def async_in_batches(options = {})
          batch_size = options[:size]  || INDEX_BATCH_DEFAULT
          types      = options[:types] || []
          enqueued   = 0

          indexable_models(types) do |type, model|
            steps = (scope_for(model).call.count / batch_size)
            p "indexing across #{steps} jobs" if options[:verbose]
            (0..steps).each do | step |
              size = step * batch_size
              SearchIndexWorker.perform_async(self.name, model.name, size, batch_size)
              p "enqueued step #{enqueued += 1}, offset #{size} - #{size + batch_size}" if options[:verbose]
            end
          end
        end

        def in_batches(options = {} )
          create_if_not_exists
          batch_size = options[:size]   || INDEX_BATCH_DEFAULT
          types      = options[:types]  || []

          indexable_models(types) do |type, model|
            start = discover_offset(model, options[:offset] || 0)
            scope_for(model).call.find_in_batches(start: start, batch_size: batch_size) do |docs|
              bulk(docs.map{ |doc| doc.to_document(inferred_index_name).merge({ _type: type.to_s }) })
            end
          end
        end

        def discover_offset(model, after)
          scope_for(model)
            .call
            .order(model.arel_table.primary_key)
            .offset(after)
            .first.try(:id) || 0
        end

        def indexable_models(*types, &block)
          models_to_index = types.flatten
          all = models
          all = models.slice(*models_to_index) if models_to_index.any?
          all.each &block
        end
      end
    end
  end
end
