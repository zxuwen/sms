$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sms"
  s.version     = Sms::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Sms."
  s.description = "TODO: Description of Sms."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "nexmo", "~> 0.4.0"

  s.add_development_dependency "sqlite3"
end
