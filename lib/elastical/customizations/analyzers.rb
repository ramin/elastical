module Elastical
  module Customizations
    class Analyzers
      attr_reader :data

      def initialize
        @data = {
          analysis: {
            analyzer: {
              phraser: phraser,
              synonym: synonyms
            },
            filter: {
              custom_shingle: custom_shingle,
              synonym: synonym_filter
            }
          }
        }
      end

      def all
        @data
      end

      def synonyms
        {
          type: "custom",
          tokenizer: "standard",
          filter: ["snowball", "lowercase", "stop", "synonym"]
        }
      end

      def synonym_filter
        {
          type: "synonym",
          synonyms_path: "analysis/synonyms.txt"
        }
      end

      def custom_shingle
        {
          type: "shingle",
          max_shingle_size: 4,
          min_shingle_size: 2,
          output_unigrams: false
        }
      end

      def phraser
        {
          type: "custom",
          tokenizer: "standard",
          filter: ["standard", "lowercase", "custom_shingle"],
          min_shingle_size: 2,
          max_shingle_size: 4
        }
      end
    end
  end
end
