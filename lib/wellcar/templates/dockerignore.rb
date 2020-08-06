require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class Dockerignore < Base
      def initialize()
        super ".dockerignore"
        with_template "dockerignore.erb"
      end
    end
  end
end
