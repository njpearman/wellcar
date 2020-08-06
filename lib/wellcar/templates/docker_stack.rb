require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class DockerStack < Base
      def initialize(app_name, repo_account)
        super "docker-stack.yml"
        with_attributes app_name: app_name,
          repo_account: repo_account,
          registry_url: "docker.pkg.github.com"
        with_template "docker-stack.yml.erb"
      end

      def image_path
        [registry_url, repo_account, app_name, "web"].join "/"
      end
      
      def proxy_image_path
        [registry_url, repo_account, app_name, "nginx"].join "/"
      end
    end
  end
end
