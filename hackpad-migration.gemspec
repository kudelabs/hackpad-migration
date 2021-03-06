# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hackpad/migration/version'

Gem::Specification.new do |spec|
  spec.name          = "hackpad-migration"
  spec.version       = Hackpad::Migration::VERSION
  spec.authors       = ["Doni Leung"]
  spec.email         = ["d@ii2d.com"]

  spec.summary       = %q{Hackpad migrator}
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.description   = %q{A tool for migrate Hackpad from one Hackpad site to other Hackpad site via Hackpad's APIs.}
  spec.homepage      = "https://github.com/kudelabs/hackpad-migration.git"
  spec.license       = "MIT"
  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # spec.bindir        = "exe"
  spec.executables   = ['hackpad-migrate']#spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'oauth', "~> 0.5.1"
  spec.add_dependency 'thor', "~> 0.19.1"
  spec.add_dependency 'nokogiri', "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 8.2"
end
