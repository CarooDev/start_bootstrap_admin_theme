$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "start_bootstrap_admin_theme/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "start_bootstrap_admin_theme"
  spec.version     = StartBootstrapAdminTheme::VERSION
  spec.authors     = ["George Mendoza"]

  spec.homepage    = "https://github.com/SnackNation/start_bootstrap_admin_theme"
  spec.summary     = "Rails engine for Start Bootstrap Admin Theme"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.4", ">= 6.1.4"

  spec.add_development_dependency "sqlite3", '~> 1.4'
  spec.add_development_dependency "rspec-rails", '>= 4.0.0.beta3'
end
