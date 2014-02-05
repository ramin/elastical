require 'elastical/base/client'
require 'elastical/base/index'
require 'elastical/base/indexing'
require 'elastical/base/management'
require 'elastical/base/mappings'
require 'elastical/base/models'
require 'elastical/base/remote'
require 'elastical/base/scopes'
require 'elastical/base/segments'

module Elastical
  class Base
    include Elastical::Base::Client
    include Elastical::Base::Index
    include Elastical::Base::Indexing
    include Elastical::Base::Management
    include Elastical::Base::Mappings
    include Elastical::Base::Models
    include Elastical::Base::Remote
    include Elastical::Base::Scopes
    include Elastical::Base::Segments

    # This Doesn't Exist....yet!!!!
    include Elastical::Query::Builders

    class << self
      def indexes(scope, options = {}, &block)
        klass = scope.respond_to?(:engine) ? scope.engine : scope
        augment_and_add_callbacks(klass)
        klass.indexed_by(inferred_index_name)
        klass.instance_eval(&block)
        setup(klass, options.merge(scope: scope) )
      end

      def augment_and_add_callbacks(klass)
        unless klass.respond_to?(:elastical?)
          klass.send(:include, Elastical::Model::Augmentations)
          klass.send(:include, Elastical::Model::Callbacks)
        end
      end

      def setup(klass, options)
        alias_name = alias_model(klass, options)
        add_model(klass, alias_name, options[:scope])
        add_scope(klass, options)

        add_mapping(alias_name, klass.mappings[inferred_index_name] )
        Elastical::Indexes << inferred_index_name
      end

      def alias_model(klass, options)
        (options[:as] || klass.name.underscore).to_sym
      end

      def named(name)
        @index_name = name
      end

      def inferred_index_name
        (@index_name.try(:downcase) || self.name.underscore.sub(/_index/, '')).to_sym
      end
    end
  end
end
