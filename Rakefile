require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "daijobu"
    gem.summary     = "A helper for de/serialization of objects into and out of Tokyo Cabinets"
    gem.email       = "sander@outside.in"
    gem.homepage    = "http://github.com/sander6/daijobu"
    gem.authors     = ["Sander Hartlage"]
    gem.files       = %w{
      LICENSE
      Rakefile
      README.rdoc
      lib/daijobu.rb
      lib/daijobu/adapter.rb
      lib/daijobu/client.rb
      lib/daijobu/errors.rb
      lib/daijobu/scheme.rb
      lib/daijobu/scheme_set.rb
      lib/adapters/mem_cache.rb
      lib/adapters/tokyo_cabinet.rb
      lib/adapters/tokyo_tyrant.rb
      lib/schemes/eval.rb
      lib/schemes/json.rb
      lib/schemes/marshal.rb
      lib/schemes/yaml.rb
    }
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
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


task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "daijobu #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

