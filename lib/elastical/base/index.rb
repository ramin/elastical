module Elastical
  class Base
    module Index
      extend ActiveSupport::Concern

      module ClassMethods
        def create_if_not_exists
          create! unless exists?
        end

        def put(model)
          doc = model.to_document(inferred_index_name)
          id = doc.delete(:_id)
          client
            .type(alias_for(model.class))
            .put(id, doc)
        end

        def delete(model)
          client
            .type(alias_for(model.class))
            .delete(model.elastical_id)
        end

        def bulk(documents)
          Elastical::Connection
            .instance
            .client
            .index(inferred_index_name)
            .bulk_index(documents)
        end
      end
    end
  end
end
