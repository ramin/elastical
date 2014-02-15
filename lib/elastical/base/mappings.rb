module Elastical
  class Base
    module Mappings
      extend ActiveSupport::Concern

      module ClassMethods
        def add_mapping(name, mapping)
          @_mappings ||= {}
          @_mappings[name] ||= default_mapping
          @_mappings[name][:properties] = mapping
          @_mappings
        end

        def default_mapping
          {
            properties: {}
          }
        end

        def mappings
          @_mappings
        end
      end
    end
  end
end
