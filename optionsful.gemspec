# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{optionsful}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marco Antonio Gonzalez Junior"]
  s.date = %q{2010-08-26}
  s.description = %q{Build RESTful web services supporting the HTTP OPTIONS verb on Ruby on Rails applications.}
  s.email = %q{kayaman@baurets.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    ".autotest",
     ".document",
     ".gitignore",
     "LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION",
     "features/optionsful.feature",
     "features/step_definitions/optionsful3_steps.rb",
     "features/support/env.rb",
     "lib/baurets/optionsful/configurator.rb",
     "lib/baurets/optionsful/introspections.rb",
     "lib/baurets/optionsful/server.rb",
     "lib/optionsful.rb",
     "optionsful.gemspec",
     "rails/init.rb",
     "samples/optionsful.yml",
     "samples/optionsful_bug.yml",
     "samples/optionsful_true.yml",
     "samples/optionsful_true_custom.yml",
     "samples/optionsful_true_custom_base_path.yml",
     "samples/optionsful_true_custom_propagate.yml",
     "spec/fake_app.rb",
     "spec/optionsful_configurator_spec.rb",
     "spec/optionsful_server_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "tasks/optionsful.rake"
  ]
  s.homepage = %q{http://github.com/kayaman/optionsful}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{optionsful}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Support HTTP OPTIONS verb on your Rails 3 app.}
  s.test_files = [
    "spec/fake_app.rb",
     "spec/optionsful_configurator_spec.rb",
     "spec/optionsful_server_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_runtime_dependency(%q<rails>, ["= 3.0.0.rc2"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<rails>, ["= 3.0.0.rc2"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<rails>, ["= 3.0.0.rc2"])
  end
end

