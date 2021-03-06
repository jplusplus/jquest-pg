$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jquest_pg/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jquest_pg"
  s.version     = JquestPg::VERSION
  s.authors     = ["Pierre Romera"]
  s.email       = ["hello@pirhoo.com"]
  s.homepage    = "http://www.pirhoo.com"
  s.summary     = "Summary of JquestPoliticalGaps."
  s.description = "Description of JquestPoliticalGaps."
  s.license     = "MIT"
  s.metadata    = {
    'season' => 'Political Gaps',
    'root_path' => 'political-gaps'
  }

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '5.0.0'
  s.add_dependency 'pundit'
  s.add_dependency 'grape-active_model_serializers'
  s.add_dependency 'active_model_serializers', '~> 0.10.0'
  s.add_dependency 'google_drive'
  s.add_dependency 'tty'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
end
