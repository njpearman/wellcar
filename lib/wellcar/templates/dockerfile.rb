require File.join(File.dirname(__FILE__), "base.rb")

module Wellcar
  module Templates
    class Dockerfile < Base
      def initialize(ruby_version, app_name, use_bundler_2=false)
        super "Dockerfile"
        with_attributes ruby_version: ruby_version, app_name: app_name, use_bundler_2: use_bundler_2
        with_template "dockerfile.erb"
      end
    end
  end
end
