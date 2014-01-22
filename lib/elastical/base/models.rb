module Elastical
  class Base
    module Models
      extend ActiveSupport::Concern

      module ClassMethods
        def add_model(klass, as, scope = nil)
          @_models ||= {}
          @_models[as] = klass
        end

        def aliases
          models.keys
        end

        def alias_of(name)
          models[name]
        end

        def alias_for(klass)
          models.select{ |k,v| v == klass }.keys.first
        end

        def classes
          models.values
        end

        def models
          @_models
        end
      end
    end
  end
end
