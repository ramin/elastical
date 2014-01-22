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
        target_indexes{ |index| index.put(self) }
      end

      def elastical_remove!
        target_indexes{ |index| index.delete(self) }
      end

      private

      def target_indexes(&block)
        self.class.indexes.each do |index|
          target_index = "#{index}_index".camelize.constantize
          if target_index.within_scope?(self)
            yield target_index
          end
        end
      end
    end
  end
end
