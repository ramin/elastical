module Elastical
  class Connection
    include Singleton

    def initialize(logger = nil)
      @clients = []
      Array.wrap(Elastical::Config.host).each do |host|
        @clients << Stretcher::Server.new(host)
      end
    end

    def clients
      @clients
    end

    def client
      # http://i.imgur.com/6o1Pp8H.jpg
      @clients.sample
    end

    def self.reset!
      Singleton.send :__init__, self
    end
  end
end
