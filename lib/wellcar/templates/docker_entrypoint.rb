require File.join(File.dirname(__FILE__), "base")

module Wellcar
  module Templates
    class DockerEntrypoint < Base
      def initialize
        super "bin/docker-entrypoint.sh"
        with_template "docker-entrypoint.sh.erb"
        after_write do
          system "chmod +x bin/docker-entrypoint.sh"
        end
      end
    end
  end
end

