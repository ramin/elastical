module Elastical
  class Search
    attr_reader :index
    attr_accessor :connection

    def initialize(index)
      @index = index
      @connection ||= Elastical::Connection.instance
    end

    def search(query)
      connection.search(index, query)
    end
  end
end
