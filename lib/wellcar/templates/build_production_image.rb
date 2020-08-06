require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class BuildProductionImage < Base
      def initialize(app_name, repo_account)
        super "build-production-image.yml"
        with_attributes app_name: app_name, repo_account: repo_account
        with_template "build-production-image.yml.erb"
        within ".github/workflows"
      end

      def repository_base_path
        [repo_account, app_name].join "/"
      end
    end
  end
end
