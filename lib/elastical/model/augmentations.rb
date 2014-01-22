module Elastical
  module Model
    module Augmentations
      extend ActiveSupport::Concern

      included do
        @_document ||= {}
        @_mappings ||= {}
      end

      module ClassMethods
        def indexed_by( index )
          @index = index

          define_singleton_method "#{@index}_mapping" do
            index_name = __method__.to_s.sub('_mapping', '')
            mapping(index_name.to_sym)
          end

          define_method "#{@index}_document" do
            index_name = __method__.to_s.sub('_document', '')
            to_document(index_name)
          end
        end

        def mapping(index)
          @_mappings[index] || {}
        end

        def field(name, args = {}, &block)
          field_name = args[:as] || name.to_sym

          @_document[@index] ||= {}
          @_document[@index][field_name] = block_given? ? block : name

          @_mappings[@index] ||= {}
          if mapping_options = Elastical::Mapping.options_to_mapping_with_defaults(args).presence
            @_mappings[@index][field_name] = mapping_options
          end
        end

        def elastical?
          true
        end

        def indexes
          @_mappings.keys
        end

        # show all documents
        def mappings
          @_mappings
        end

        def documents
          @_document
        end
      end

      def elastical_id
        "#{self.class.name.underscore}-#{self.id}".downcase
      end

      # Instance Methods
      def to_document(index)
        doc = { _id: self.elastical_id }
        self.class.documents[index.to_sym].each do |key, value|
          doc[key] =  value.is_a?(Proc) ? value.call(self) : self.send(value)
        end
        doc
      end
    end
  end
end
