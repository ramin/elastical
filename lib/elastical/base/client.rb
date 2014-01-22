module Elastical
  class Base
    module Client
      extend ActiveSupport::Concern

      module ClassMethods
        private

        def client
          Elastical::Connection.instance.client.index(inferred_index_name)
        end
      end
    end
  end
end
