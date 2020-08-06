require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class EnvProductionWeb < Base
      def initialize(master_key)
        super ".env/production/web"
        with_template "env_production_web.erb"
        with_attributes master_key: master_key 
      end
    end
  end
end

