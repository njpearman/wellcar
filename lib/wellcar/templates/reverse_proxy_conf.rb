require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class ReverseProxyConf < Base
      def initialize(domain_name)
        super "reverse-proxy.conf"
        with_attributes domain_name: domain_name
        with_template "reverse-proxy.conf.erb"
        within "config/nginx"
      end
    end
  end
end
