# frozen_string_literal: true

require_relative "lib/turbo_component/version"

Gem::Specification.new do |spec|
  spec.name        = "turbo_component"
  spec.version     = TurboComponent::VERSION
  spec.authors     = ["Jose Galisteo"]
  spec.email       = ["ceritium@gmail.com"]
  spec.homepage    = "https://github.com/ceritium/turbo_component"
  spec.summary     = "Components with super powers"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ceritium/turbo_component"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 4.0.0"
  spec.add_dependency "turbo-rails", ">= 0"
end
