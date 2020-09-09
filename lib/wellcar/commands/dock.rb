module Wellcar
  module Commands
    class Dock < Base
      def initialize(github_account, domain_name)
        self.github_account = github_account
        self.domain_name = domain_name
      end

      def interpret_app_name
        app_name = File.read("./config/application.rb")
          .split("\n")
          .select {|line| line =~ /^module / }
          .first
          &.split
          &.last
          &.downcase

        return app_name unless app_name.nil?

        puts "Cannot determine app name from config/application.rb. wellcar expects to find one module in this file named for the application."
        exit 5
      end

      def interpret_ruby_version
        File.file?(".ruby_version") ?
          File.read(".ruby_version").split.first :
          "2.6.6"
      end

      def interpret_bundler_2
        b2 = File.file?("Gemfile.lock") &&
          File.read("Gemfile.lock").split("BUNDLED WITH")&.last.strip >= "2.0.0"
        puts "Install bundler 2? #{b2}"
        b2
      end

      def determine_variables
        self.app_name = interpret_app_name
        self.ruby_version = interpret_ruby_version
        self.use_bundler_2 = interpret_bundler_2
      end

      def prepare_templates
        docker_files
      end

      def docker_files
        @files ||= core_docker_templates.push(Wellcar::Templates::DockerCompose.new(app_name, github_account))
      end

      def check_existing_files(force_new)
        files_exist = docker_files.select {|file| file.exist? }.any?
        if force_new && files_exist
          puts "--force-new set. Overwriting **all** existing docker files."

          if Dir.exist? ".env"
            label = Time.new.strftime("%Y%m%d%H%M%S")
            puts ".env will be backed up to .wellcar/env-#{label}"
            destination = ".wellcar/env-#{label}"
            FileUtils.copy_entry ".env", destination
            exit unless Dir.exist? destination
          end
        elsif files_exist
          puts "Found existing docker files. Please check your app source tree before trying to dockerise this app with wellcar again."
          exit 3
        end
      end

      def update_database_config
        Wellcar::Templates::DatabaseYaml.new(app_name).update
        puts <<-DB
     ... updated development settings for database.yml.
    Now using dockerised PostgreSQL server. Previous config saved as config/database.pre_docker.yml
    DB

        Wellcar::Templates::ApplicationSystemTestCase.new.update
        puts <<-TESTS
     ... updated ApplicationSystemTestCase class.
    Now using dockerised system tests. Previous ApplicationSystemTestCase saved as test/application_system_test_case.pre_docker.rb
TESTS
            
      end

      # This does not currently work, as it is called before bundle is available. I'm debating how
      # to include this "gem tidying" aspect of adding Docker to an existing project.
      def tidy_gemfile
        %w(sqlite3 figaro dotenv).each {|gem| system "docker-compose run --rm bin/bundle remove #{gem}" }
        system "docker-compose run --rm bin/bundle add pg" unless system("docker-compose run --rm bin/bundle info pg")
      end

      def call(options, args)
        create_wellcar_folder
        determine_variables
        prepare_templates
        check_existing_files options[:"force-new"]
        create_directories
        write_files
        update_database_config
        clean_docker
        # This assumes bin/bundle is available, which will not be the case.
        # The gem set up done in this call should be part of a Dockerfile, but needs
        # a script to manage some conditional logic.
        # tidy_gemfile
        build_development_environment

        puts <<-DONE
    Your Rails app has been dockerised!

    You can use wellcar to interact with the Docker containers and the Rails application as you develop your app.

    Run `wellcar` for help with commands.
    DONE
      end
    end
  end
end
