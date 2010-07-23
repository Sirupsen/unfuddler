require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "unfuddler"
    gem.summary = %Q{Provides a simple Ruby API to Unfuddle.}
    gem.description = %Q{Provides a simple Ruby API to Unfuddle.}
    gem.email = "sirup@sirupsen.dk"
    gem.homepage = "http://github.com/Sirupsen/unfuddler"
    gem.authors = ["Sirupsen"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_dependency "hashie", ">= 0.2.0"
    gem.add_dependency "crack", ">= 0.1.6"
    gem.add_dependency "activesupport", ">= 2.3.5"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "unfuddler #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
