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

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0.1"
  spec.add_development_dependency "rspec", "~> 3.9.0"
  spec.add_development_dependency "guard", "~> 2.16.2"
  spec.add_development_dependency "guard-rspec", "~> 4.7", ">= 4.7.3"
  spec.add_development_dependency "pry", "~> 0.13.1"
  spec.add_development_dependency "rubocop", "~> 0.90.0"

  spec.add_dependency "json", "~> 2.3.1"
  spec.add_dependency "rest-client", "~> 2.1", ">= 2.1.0"
  spec.add_dependency "activesupport", "~> 6.0"
  spec.add_dependency "i18n", "~> 1.8.5"
  spec.add_dependency "parallel", "~> 1.12.1"
end
