Gem::Specification.new do |s|
  s.name            = 'logstash-output-mongo'
  s.version         = '1.0.1'
  s.licenses        = ['Apache License (2.0)']
  s.summary         = "MongoDB CRUD Operations (insert, update, upsert & delete)"
  s.description     = "Logstash plugin. MongoDB CRUD Operations (insert, update, upsert & delete) for logstash. This gem is a fork of the Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname."
  s.authors         = ["Elastic", "@lancha90"]
  s.email           = 'diegomao627@gmail.com'
  s.homepage        = "https://github.com/lancha90/logstash-output-mongo"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir["lib/**/*","spec/**/*","*.gemspec","*.md","CONTRIBUTORS","Gemfile","LICENSE","NOTICE.TXT", "vendor/jar-dependencies/**/*.jar", "vendor/jar-dependencies/**/*.rb", "VERSION", "docs/**/*"]

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'mongo', '~> 2.6'
  s.add_runtime_dependency 'bson', '4.7.0'

  s.add_development_dependency 'logstash-devutils'
end

