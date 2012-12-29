# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent-plugin-outing/version'

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-outing"
  gem.version       = Fluent::Plugin::Outing::VERSION
  gem.authors       = ["Yoshinori Tahara"]
  gem.email         = ["tahara@actindi.net"]
  gem.description   = %q{iko-yo app log}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "fluentd"
  gem.add_runtime_dependency "mongo"
end
