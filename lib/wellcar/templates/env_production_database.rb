require File.join(File.dirname(__FILE__), "base")
require "securerandom"

module Wellcar
  module Templates
    class EnvProductionDatabase < Base
      def initialize(app_name)
        super ".env/production/database"
        with_attributes app_name: app_name,
          password: SecureRandom.base64(20)
        with_template "env_production_database.erb"
      end
    end
  end
end

