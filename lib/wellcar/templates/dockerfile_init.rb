require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class DockerfileInit < Base
      def initialize(ruby_version, app_name)
        super "Dockerfile.init"
        with_attributes ruby_version: ruby_version, app_name: app_name
        with_template "dockerfile_init.erb"
      end

      def skips
        skip_on_new = %w(bundle webpack-install test)
        skip_on_new.map {|s| "\"--skip-#{s}\"" }.join(", ")
      end
    end
  end
end
