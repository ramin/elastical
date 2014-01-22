module Elastical
  class Config
    include Singleton

    class << self
      def host
        instance.host
      end
    end

    def config
      @config ||= begin
        file = YAML::load( File.open( "#{Rails.root}/config/elasticsearch.yml" ) )
        file[Rails.env] || raise("No config for #{Rails.env} defined in config/elasticsearch.yml")
      end
    end

    def host
      config["host"]
    end
  end
end
