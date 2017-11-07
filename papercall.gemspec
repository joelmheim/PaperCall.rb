# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'papercall/version'

Gem::Specification.new do |spec|
  spec.name          = "papercall"
  spec.version       = Papercall::VERSION
  spec.authors       = ["Jørn Ølmheim"]
  spec.email         = ["jorn@olmheim.com"]

  spec.summary       = "Small client library for the PaperCall API"
  spec.description   = "Small client library for the PaperCall API. With some analytics for the submissions."
  spec.homepage      = "https://github.com/joelmheim/PaperCall.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard", "~> 2.13"
  spec.add_development_dependency "guard-rspec", "~> 4.7", ">= 4.7.3"
  spec.add_development_dependency "pry", "~> 0.11.2"
  spec.add_development_dependency "rubocop", "~> 0.51.0"

  spec.add_dependency "json", "~> 2.1"
  spec.add_dependency "rest-client", "~> 2.0", ">= 2.0.2"
end
