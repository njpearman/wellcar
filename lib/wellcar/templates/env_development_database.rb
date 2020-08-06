require "securerandom"
require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class EnvDevelopmentDatabase < Base
      def initialize(app_name)
        super ".env/development/database"
        with_attributes app_name: app_name,
          password: SecureRandom.base64(20)
        with_template "env_development_database.erb"
      end
    end
  end
end
