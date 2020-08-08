module Wellcar
  module Commands
    class Base
      attr_accessor :ruby_version,
        :app_name,
        :use_bundler_2,
        :github_account,
        :domain_name

      def core_docker_templates
         master_key = File.exist?("config/credentials/production.key") ?
           File.read("config/credentials/production.key") :
           nil

        [
          Wellcar::Templates::Dockerfile.new(ruby_version, app_name, use_bundler_2),
          Wellcar::Templates::DockerStack.new(app_name, github_account),
          Wellcar::Templates::EnvDevelopmentDatabase.new(app_name),
          Wellcar::Templates::EnvDevelopmentWeb.new,
          Wellcar::Templates::EnvProductionWeb.new(master_key),
          Wellcar::Templates::EnvProductionDatabase.new(app_name),
          Wellcar::Templates::Dockerignore.new,
          Wellcar::Templates::DockerEntrypoint.new,
          Wellcar::Templates::BuildProductionImage.new(app_name, github_account),
          Wellcar::Templates::ReverseProxyConf.new(domain_name)
        ]
      end

      def create_directories
        FileUtils.mkdir_p "config"
        FileUtils.mkdir_p "bin"
        FileUtils.mkdir_p ".env/development"
        FileUtils.mkdir_p ".env/production"
      end

      def write_files
        files_before_docker = Dir['*']
        
        system "curl -o bin/wait-for https://raw.githubusercontent.com/mrako/wait-for/master/wait-for"

        docker_files.each(&:write)
        puts "Wellcar created:\n#{Dir['*'] - files_before_docker}\n"
      end

      def create_wellcar_folder
        return if Dir.exist? ".wellcar"

        Dir.mkdir ".wellcar"
        FileUtils.touch ".wellcar/.keep"
      end

      def clean_docker
        # Make sure that no pre-existing containers are running. Although 
        # very unlikely, it's worth being thorough. This makes the command
        # slow but for the time being this ensures the containers and images
        # are as expected.
        exit 8 unless system "docker-compose down --remove-orphans"

        removable_volumes = ["#{app_name}_gem_cache", "#{app_name}_node_modules"]
        volumes_to_remove = %x(docker volume ls --format='{{.Name}}')
          .split("\n") & removable_volumes

        return if volumes_to_remove.empty?

        puts "Removing the following volumes: #{volumes_to_remove.join(", ")}"

        system "docker volume rm #{volumes_to_remove.join(" ")}"
      end
      
      def build_development_environment
        exit 128 unless system "docker-compose build web webpack-dev-server database"
      end
    end
  end
end
