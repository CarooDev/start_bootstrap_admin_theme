$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "start_bootstrap_admin_theme/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "start_bootstrap_admin_theme"
  spec.version     = StartBootstrapAdminTheme::VERSION
  spec.authors     = ["George Mendoza"]
  spec.email       = ["george.mendoza@snacknation.com"]
  spec.homepage    = "http://www.snacknation.com"
  spec.summary     = "Rails engine for Start Bootstrap Admin Theme"
  spec.description = "Rails engine for Start Bootstrap Admin Theme"
  spec.license     = "All rights reserved."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # http://gems.snacknation.com currently doesn't exist. We just want
    # to set allowed_push_host to protect against public gem pushes.
    spec.metadata["allowed_push_host"] = "http://gems.snacknation.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.2", ">= 6.0.2.1"

  spec.add_development_dependency "sqlite3"
end
