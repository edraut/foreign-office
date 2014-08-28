# -*- encoding: utf-8 -*-
# stub: github-pages 23 ruby lib

Gem::Specification.new do |s|
  s.name = "github-pages"
  s.version = "23"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["GitHub, Inc."]
  s.date = "2014-08-26"
  s.description = "Bootstrap the GitHub Pages Jekyll environment locally."
  s.email = "support@github.com"
  s.executables = ["github-pages"]
  s.files = ["bin/github-pages"]
  s.homepage = "https://github.com/github/pages-gem"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.2.2"
  s.summary = "Track GitHub Pages dependencies."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jekyll>, ["= 2.2.0"])
      s.add_runtime_dependency(%q<jekyll-coffeescript>, ["= 1.0.0"])
      s.add_runtime_dependency(%q<jekyll-sass-converter>, ["= 1.2.0"])
      s.add_runtime_dependency(%q<kramdown>, ["= 1.3.1"])
      s.add_runtime_dependency(%q<maruku>, ["= 0.7.0"])
      s.add_runtime_dependency(%q<rdiscount>, ["= 2.1.7"])
      s.add_runtime_dependency(%q<redcarpet>, ["= 3.1.2"])
      s.add_runtime_dependency(%q<RedCloth>, ["= 4.2.9"])
      s.add_runtime_dependency(%q<liquid>, ["= 2.6.1"])
      s.add_runtime_dependency(%q<pygments.rb>, ["= 0.6.0"])
      s.add_runtime_dependency(%q<jemoji>, ["= 0.3.0"])
      s.add_runtime_dependency(%q<jekyll-mentions>, ["= 0.1.3"])
      s.add_runtime_dependency(%q<jekyll-redirect-from>, ["= 0.6.0"])
      s.add_runtime_dependency(%q<jekyll-sitemap>, ["= 0.5.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
    else
      s.add_dependency(%q<jekyll>, ["= 2.2.0"])
      s.add_dependency(%q<jekyll-coffeescript>, ["= 1.0.0"])
      s.add_dependency(%q<jekyll-sass-converter>, ["= 1.2.0"])
      s.add_dependency(%q<kramdown>, ["= 1.3.1"])
      s.add_dependency(%q<maruku>, ["= 0.7.0"])
      s.add_dependency(%q<rdiscount>, ["= 2.1.7"])
      s.add_dependency(%q<redcarpet>, ["= 3.1.2"])
      s.add_dependency(%q<RedCloth>, ["= 4.2.9"])
      s.add_dependency(%q<liquid>, ["= 2.6.1"])
      s.add_dependency(%q<pygments.rb>, ["= 0.6.0"])
      s.add_dependency(%q<jemoji>, ["= 0.3.0"])
      s.add_dependency(%q<jekyll-mentions>, ["= 0.1.3"])
      s.add_dependency(%q<jekyll-redirect-from>, ["= 0.6.0"])
      s.add_dependency(%q<jekyll-sitemap>, ["= 0.5.1"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
    end
  else
    s.add_dependency(%q<jekyll>, ["= 2.2.0"])
    s.add_dependency(%q<jekyll-coffeescript>, ["= 1.0.0"])
    s.add_dependency(%q<jekyll-sass-converter>, ["= 1.2.0"])
    s.add_dependency(%q<kramdown>, ["= 1.3.1"])
    s.add_dependency(%q<maruku>, ["= 0.7.0"])
    s.add_dependency(%q<rdiscount>, ["= 2.1.7"])
    s.add_dependency(%q<redcarpet>, ["= 3.1.2"])
    s.add_dependency(%q<RedCloth>, ["= 4.2.9"])
    s.add_dependency(%q<liquid>, ["= 2.6.1"])
    s.add_dependency(%q<pygments.rb>, ["= 0.6.0"])
    s.add_dependency(%q<jemoji>, ["= 0.3.0"])
    s.add_dependency(%q<jekyll-mentions>, ["= 0.1.3"])
    s.add_dependency(%q<jekyll-redirect-from>, ["= 0.6.0"])
    s.add_dependency(%q<jekyll-sitemap>, ["= 0.5.1"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
  end
end
