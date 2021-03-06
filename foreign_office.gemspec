$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foreign_office/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "foreign_office"
  s.version     = ForeignOffice::VERSION
  s.authors     = ["Eric Draut","Adam Bialek"]
  s.email       = ["edraut@gmail.com"]
  s.homepage    = "http://edraut.github.io/foreign-office"
  s.summary     = "A light framework that provides functionality for listeners on web clients and publishers on ruby servers. Keep your business logic on the server whenever you can!"
  s.description = "A light framework that provides functionality for listeners on web clients and publishers on ruby servers. Keep your business logic on the server whenever you can!"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "app/assets/javascripts/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]
  s.add_dependency "rails", ">= 5.1", "< 6"
  s.add_dependency "request_store", "< 2.0"

  s.add_development_dependency "sqlite3", "< 2.0"
  s.add_development_dependency "minitest", "< 6.0"
end
