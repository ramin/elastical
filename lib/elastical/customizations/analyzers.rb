module Elastical
  module Customizations
    class Analyzers
      attr_reader :data

      def[](key)
        @data[key]
      end

      def initialize
        @data = {
          analysis: {
            analyzer: {
              phraser: phraser
            },
            filter: {
              custom_shingle: custom_shingle
            }
          }
        }
        @data
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
