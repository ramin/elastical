module Elastical
  class Base
    module Segments
      extend ActiveSupport::Concern

      module ClassMethods
        def segment(options = {})
          indexable_models(options[:type] || []) do |type, model|
            segment_query(model, options) do |docs|
              bulk(docs.map{ |doc| doc.to_document(inferred_index_name).merge({ _type: type.to_s }) })
            end
          end
        end

        private

        def upper_bounds(model, current_offset, size)
          scope_for(model)
            .call
            .order(model.arel_table.primary_key)
            .offset(current_offset)
            .limit(size)
            .last.id
        end

        def segment_query(model, options, &block)
          # scopes
          segments        = options[:segments] || 3
          current_segment = (options[:segment] - 1) || 1

          # segments sizes
          divmod          = scope_for(model).call.count.divmod(segments)
          current_offset  = current_segment * divmod.first
          current_limit   = current_segment == (segments - 1) ?  divmod.sum : divmod.first
          start_id        = discover_offset(model, current_offset)
          max_id          = upper_bounds(model, current_offset, current_limit)
          table           = model.arel_table

          unless options[:dry]
            scope_for(model).call
              .where(table.primary_key.lteq(max_id))
              .find_in_batches(start: start_id, batch_size: 1000, &block)
          end
        end
      end
    end
  end
end
