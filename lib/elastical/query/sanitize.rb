module Elastical
  module Query
    class Sanitize

      QUERY_OPERATORS = %w(AND OR NOT)

      class << self

        def escape_string(query_string)
          query_string = escape_special_characters(query_string)
          query_string = escape_operators(query_string)
          query_string = escape_quotes(query_string)
          query_string
        end

        private

        def escape_quotes(string)
          quote_count = string.count '"'
          string = string.gsub(/(.*)"(.*)/, '\1\"\3') if quote_count % 2 == 1
          string
        end

        def escape_operators(string)
          QUERY_OPERATORS.each do |word|
            escaped_word = word.split('').map {|char| "\\#{char}" }.join('')
            string = string.gsub(/\s*\b(#{word.upcase})\b\s*/, " #{escaped_word} ")
          end
          string
        end

        def escape_special_characters(string)
          # http://lucene.apache.org/core/old_versioned_docs/versions/2_9_1/queryparsersyntax.html#Escaping Special Characters
          string.gsub(/([#{escaped_characters}])/, '\\\\\1')
        end

        def escaped_characters
          Regexp.escape('\\+-&|!(){}[]^~*?:')
        end
      end
    end
  end
end
