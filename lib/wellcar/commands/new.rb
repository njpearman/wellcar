module Wellcar
  module Commands
    class New < Base
      def initialize(app_name, github_account, domain_name)
        self.app_name = app_name
        self.domain_name = domain_name
        self.github_account = github_account
        self.ruby_version = "2.6.6"
        self.use_bundler_2 = true
      end

      def docker_files
        @files ||= core_docker_templates.push(
          Wellcar::Templates::DockerfileInit.new(ruby_version, app_name),
          Wellcar::Templates::DockerCompose.new(app_name, 
                                                github_account,
                                                Wellcar::Templates::DockerCompose::INIT_TEMPLATE)
        )
      end

      def try_full_nuke(nuke)
        if nuke && Dir.exists?(app_name)
          puts "*** Destroying the existing folder #{app_name} ***"
          FileUtils.rm_rf app_name
        elsif Dir.exists? app_name
          puts "Cannot overwrite existing folder #{Dir.pwd}/#{app_name}"
          exit 1
        end
      end

      def within_app_folder(&block)
        raise NotImplemented if block.nil?

        Dir.mkdir app_name

        Dir.chdir(app_name) do
          yield
        end
      end

      def perform_setup
        # Create app and install webpacker
        exit 16 unless system "docker-compose up --build new_rails"
        exit 32 unless system "docker-compose up --build bundle"
        exit 64 unless system "docker-compose up --build install_webpacker"
        puts "Rails app created; initializing for Docker\n"
      end

      def tidy_up_setup
        # remove dockerfile.init and docker-compose.yml with initialisation services
        %w(Dockerfile.init docker-compose.yml config/database.yml).each {|f| File.delete(f) if File.file?(f) }
        # Create docker-compose.yml file
        Wellcar::Templates::DockerCompose.new(app_name, github_account).write
        Wellcar::Templates::DatabaseYaml.new(app_name).write
        Wellcar::Templates::ApplicationSystemTestCase.new.write
      end

      def call(options, args)
        # Here we want to create a new rails app that is set up with docker.
        # We use `rails new` within a `docker run` command but skip a lot of set up so 
        # that further setup steps can be taken later on.
        # What I don't know right now is how steps that are skipped at the start can be
        # initiated in an existing app.
        #
        # My list of pre-requisites for a Rails app are:
        #   * RSpec
        #   * Webpack + yarn
        #   * Rubocop
        #   * PostgreSQL
        #   * Redis
        #   * FactoryBot
        #   * Capybara with a real webdriver
        #   * Devise

        try_full_nuke options[:full_nuke]

        within_app_folder do
          create_wellcar_folder
          create_directories
          write_files
          clean_docker
          perform_setup
          tidy_up_setup
          build_development_environment
        end
        
        puts <<-FINISHED
    Your new Rails application "#{app_name}" has been created with Docker!

    Don't forget to commit everything to git.

    You can use wellcar to interact with the Docker containers and the Rails application as you develop your app.

    Run `wellcar` for help with commands.
    FINISHED
      end
    end
  end
end
