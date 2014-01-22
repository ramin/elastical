module Elastical
  class Base
    module Scopes
      extend ActiveSupport::Concern

      module ClassMethods
        def add_scope(klass, options)
          @_scopes ||= {}
          @_scopes[klass] = -> { options[:scope] || klass }
        end

        def scope_for(klass)
          scopes[klass] || klass
        end

        def scopes
          @_scopes
        end

        def within_scope?(instance)
          klass = instance.class
          primary_key = klass.primary_key
          predicate = klass.arel_table[primary_key].eq(instance.send(primary_key))

          scope_for(klass).call
            .where(predicate)
            .exists?
        end
      end
    end
  end
end
