# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ip2cityisp/version'

Gem::Specification.new do |spec|
  spec.name          = "ip2cityisp"
  spec.version       = Ip2cityisp::VERSION
  spec.authors       = ["geda"]
  spec.email         = ["beidou77@gmail.com"]
  spec.summary       = %q{query ip from which city and isp}
  spec.description   = %q{return isp and city}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 0.9"
  spec.add_development_dependency "bindata", "~> 2.1"
end
