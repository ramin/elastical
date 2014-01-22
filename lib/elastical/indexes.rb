module Elastical
  class Indexes
    class << self
      def <<(index)
        accessor << index.to_sym
      end

      def exists?(index)
        !!accessor.member?(index)
      end

      def all
        accessor.to_a
      end

      def empty!
        @_indexes = Set.new([])
      end

      private
      def accessor
        @_indexes ||= Set.new([])
      end
    end
  end
end
