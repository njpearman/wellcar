require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class DockerCompose < Base
      INIT_TEMPLATE = "docker-compose-init.yml.erb"

      def initialize(app_name, repo_account, template_name="docker-compose.yml.erb")
        super "docker-compose.yml"
        with_attributes app_name: app_name,
          template_name: template_name,
          repo_account: repo_account,
          registry_url: "docker.pkg.github.com"
        with_template template_name
      end

      def image_path
        [registry_url, repo_account, app_name, "web"].join "/"
      end
    end
  end
end
