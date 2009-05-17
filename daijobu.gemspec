# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{daijobu}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sander Hartlage"]
  s.date = %q{2009-05-14}
  s.email = %q{sander@outside.in}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "lib/daijobu.rb",
    "lib/daijobu/adapter.rb",
    "lib/daijobu/client.rb",
    "lib/daijobu/errors.rb",
    "lib/daijobu/scheme.rb",
    "lib/daijobu/scheme_set.rb",
    "lib/daijobu/adapters/mem_cache.rb",
    "lib/daijobu/adapters/tokyo_cabinet.rb",
    "lib/daijobu/adapters/tokyo_tyrant.rb",
    "lib/daijobu/schemes/eval.rb",
    "lib/daijobu/schemes/json.rb",
    "lib/daijobu/schemes/marshal.rb",
    "lib/daijobu/schemes/raw.rb",
    "lib/daijobu/schemes/yaml.rb"
  ]
  s.homepage = %q{http://github.com/sander6/daijobu}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A helper for de/serialization of objects into and out of Tokyo Cabinets}
  s.test_files = [
    "spec/daijobu/adapter_spec.rb",
    "spec/daijobu/adapters/mem_cache_spec.rb",
    "spec/daijobu/adapters/tokyo_cabinet_spec.rb",
    "spec/daijobu/adapters/tokyo_tyrant_spec.rb",
    "spec/daijobu/client_spec.rb",
    "spec/daijobu/errors_spec.rb",
    "spec/daijobu/scheme_set_spec.rb",
    "spec/daijobu/scheme_spec.rb",
    "spec/daijobu/schemes/eval_spec.rb",
    "spec/daijobu/schemes/json_spec.rb",
    "spec/daijobu/schemes/marshal_spec.rb",
    "spec/daijobu/schemes/raw_spec.rb",
    "spec/daijobu/schemes/yaml_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
