module Elastical
  class Setup
    def self.initialize
      if block_given?
        yield Elastical::Config.instance
      else
        Elastical::Config.instance
      end
    end
  end
end
