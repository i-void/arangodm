# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arangodm/version'

Gem::Specification.new do |spec|
  spec.name          = 'arangodm'
  spec.version       = Arangodm::VERSION
  spec.authors       = ['Onur Eren Elibol']
  spec.email         = ['onurelibol@gmail.com']

  spec.summary       = 'Missing ODM of Arangodb for Ruby/Rails'
  spec.description   = 'Missing ODM of Arangodb for Ruby/Rails'
  spec.homepage      = "https://github.com/codem4ster/arangodm"
  spec.license       = 'MIT'

  spec.metadata["yard.run"] = "yri" # use "yard" to build full HTML docs.


  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://github.com/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.10'
  spec.add_development_dependency 'mocha', '~> 1.2'
  spec.add_development_dependency 'simplecov'

  spec.add_dependency 'rest-client', '~> 2.0'
  spec.add_dependency 'active_attr'
  spec.add_dependency 'sig'
end
