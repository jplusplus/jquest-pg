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
    'root_path' => 'pg'
  }

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"
  # Allow references with a different name (usefull with engine-prefixed tables)
  # See https://github.com/SchemaPlus/schema_plus_foreign_keys#migrations
  s.add_dependency "schema_plus_foreign_keys"
  s.add_development_dependency "sqlite3"
end
