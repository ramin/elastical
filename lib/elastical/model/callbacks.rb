module Elastical
  module Model
    module Callbacks
      extend ActiveSupport::Concern

      def save_and_update_index
        if save
          elastical_update!
        end
      end

      def elastical_update!
        target_indexes(:put){ |index| index.put(self) }
      end

      def elastical_remove!
        target_indexes(:delete){ |index| index.delete(self) }
      end

      private

      def target_indexes(operation, &block)
        self.class.indexes.each do |index|
          target_index = "#{index}_index".camelize.constantize
          if operation == :put
            yield target_index if target_index.within_scope?(self)
          else
            yield target_index
          end
        end
      end
    end
  end
end
