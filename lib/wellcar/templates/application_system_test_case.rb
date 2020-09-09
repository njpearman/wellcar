require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class ApplicationSystemTestCase < Base
      def initialize
        super "test/application_system_test_case.rb"
        with_template "application_system_test_case.rb.erb"
      end

      def update
        # back up existing file
        FileUtils.mv file_path, "test/application_system_test_case.pre_docker.rb"
        self.write
      end
    end
  end
end

