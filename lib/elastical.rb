require 'active_support/concern'
require 'singleton'
require 'stretcher'

module Elastical
  autoload :Base,       'elastical/base'
  autoload :Config,     'elastical/config'
  autoload :Connection, 'elastical/connection'
  autoload :Indexes,    'elastical/indexes'
  autoload :Mapping,    'elastical/mapping'
  autoload :Model,      'elastical/model'
  autoload :Pagination, 'elastical/pagination'
  autoload :Query,      'elastical/query'
  autoload :Search,     'elastical/search'
  autoload :Setup,      'elastical/setup'
end
