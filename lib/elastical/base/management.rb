module Elastical
  class Base
    module Management
      extend ActiveSupport::Concern

      module ClassMethods
        def create!
          client.create(settings: Elastical::Customizations::Analyzers.new.all, mappings: mappings )
        end

        def update!
          create!
        end

        def delete!
          client.delete
        end

        def recreate!
          delete! if exists?
          create!
        end

        def refresh!
          client.refresh
        end

        def exists?
          client.exists?
        end
      end
    end
  end
end
