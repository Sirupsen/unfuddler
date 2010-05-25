# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{unfuddler}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sirupsen"]
  s.date = %q{2010-05-25}
  s.description = %q{Provides a simple Ruby API to Unfuddle.}
  s.email = %q{sirup@sirupsen.dk}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "lib/unfuddler.rb",
     "test/helper.rb",
     "test/test_unfuddler.rb",
     "unfuddler.gemspec"
  ]
  s.homepage = %q{http://github.com/Sirupsen/unfuddler}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Provides a simple Ruby API to Unfuddle.}
  s.test_files = [
    "test/helper.rb",
     "test/test_unfuddler.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<hashie>, [">= 0.2.0"])
      s.add_runtime_dependency(%q<crack>, [">= 0.1.6"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.5"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<hashie>, [">= 0.2.0"])
      s.add_dependency(%q<crack>, [">= 0.1.6"])
      s.add_dependency(%q<activesupport>, [">= 2.3.5"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<hashie>, [">= 0.2.0"])
    s.add_dependency(%q<crack>, [">= 0.1.6"])
    s.add_dependency(%q<activesupport>, [">= 2.3.5"])
  end
end

