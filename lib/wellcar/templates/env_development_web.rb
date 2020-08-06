require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class EnvDevelopmentWeb < Base
      attr_accessor :app_name

      def initialize
        super ".env/development/web"
        with_template "env_development_web.erb"
      end
    end
  end
end
