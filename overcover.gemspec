# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'overcover/version'

Gem::Specification.new do |spec|
  spec.name          = "overcover"
  spec.version       = Overcover::VERSION
  spec.authors       = ["Chris Stevenson"]
  spec.email         = ["zhcchz@gmail.com"]

  spec.summary       = %q{Find the sweet spot for test coverage}
  spec.description   =
      %q{
      Specs that cover too many files are slow and awkward to debug.
      Files covered by too many specs are hard to change.
      Find the sweet spot.
      }
  spec.homepage      = "http://github.com/skizz/overcover"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
