module Elastical
  class Base
    module Remote
      extend ActiveSupport::Concern

      module ClassMethods
        def settings
          client.get_settings
        end

        def status
          client.status
        end

        def stats
          client.stats
        end

        def remote_mappings
          client.get_mapping
        end
      end
    end
  end
end
