# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'item/version'

Gem::Specification.new do |s|
  s.name          = "item"
  s.version       = Item::VERSION
  s.authors       = ["Lasse Bunk"]
  s.email         = ["lasse@bunk.io"]
  s.summary       = %q{Ruby on Rails semantic markup and microdata.}
  s.description   = %q{Item is a Ruby on Rails plugin for integrating semantic markup and microdata without getting view code messed up.}
  s.homepage      = "https://github.com/lassebunk/item"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.test_files    = s.files.grep(%r{^test/})
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 3.2.0"

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3", '~> 1.3.13'
end
