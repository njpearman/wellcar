require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class DatabaseYaml < Base
      def initialize(app_name)
        super "config/database.yml"
        with_attributes app_name: app_name
        with_template "database.yml.erb"
      end

      def update
        # back up existing file
        FileUtils.mv file_path, "config/database.pre_docker.yml"
        self.write
      end
    end
  end
end

