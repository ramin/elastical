module Elastical
  module Query
    class SanitizedString
      def initialize(query)
        @data = Elastical::Query::Sanitize.escape_string(query)
      end

      def to_s
        @data
      end

      def to_str
        @data
      end
    end
  end
end
