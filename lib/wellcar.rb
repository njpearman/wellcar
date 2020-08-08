require 'wellcar/version.rb'
require 'wellcar/commands/base.rb'
require 'wellcar/commands/new.rb'
require 'wellcar/commands/dock.rb'
require 'wellcar/templates/base.rb'
require 'wellcar/templates/dockerfile.rb'
require 'wellcar/templates/dockerfile_init.rb'
require 'wellcar/templates/dockerignore.rb'
require 'wellcar/templates/docker_compose.rb'
require 'wellcar/templates/docker_stack.rb'
require 'wellcar/templates/database_yaml.rb'
require 'wellcar/templates/docker_entrypoint.rb'
require 'wellcar/templates/env_development_database.rb'
require 'wellcar/templates/env_development_web.rb'
require 'wellcar/templates/env_production_database.rb'
require 'wellcar/templates/env_production_web.rb'
require "wellcar/templates/build_production_image"
require "wellcar/templates/reverse_proxy_conf"

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
