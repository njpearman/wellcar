# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','wellcar','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'wellcar'
  s.version = Wellcar::VERSION
  s.author = 'NJ Pearman'
  s.email = 'n.pearman@gmail.com'
  s.homepage = 'http://github.com/njpearman/wellcar'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A command line suite to ease conventional use of a Docker-based dev env for Ruby on Rails'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.extra_rdoc_files = ['README.rdoc','wellcar.rdoc']
  s.rdoc_options << '--title' << 'wellcar' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'wellcar'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_runtime_dependency('gli','2.19.0')
end
