$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foreign_office/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "foreign_office"
  s.version     = ForeignOffice::VERSION
  s.authors     = ["Eric Draut","Adam Bialek"]
  s.email       = ["edraut@gmail.com"]
  s.homepage    = "TBD"
  s.summary     = "A light framework that provides functionality for listeners on web clients and publishers on ruby servers. Keep your business logic on the server whenever you can!"
  s.description = "Description of ForeignOffice."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "app/assets/javascripts/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.5"
  s.add_dependency "request_store"
  
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "minitest"
end
