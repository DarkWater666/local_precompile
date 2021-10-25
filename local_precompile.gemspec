lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'local_precompile/version'

Gem::Specification.new do |gem|
  gem.name          = 'local_precompile'
  gem.version       = LocalPrecompile::VERSION
  gem.authors       = %w[DarkWater]
  gem.email         = %w[denis.arushanov@darkcreative.ru]

  gem.summary       = 'Local compile assets and packs for Capistrano'
  gem.description   = 'Contains cap tasks'
  gem.homepage      = 'https://github.com/DarkWater666/local_precompile'

  gem.license       = 'MIT'

  if gem.respond_to?(:metadata)
    gem.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(/^(test|spec|features)/) }
  gem.bindir        = 'exe'
  gem.executables   = gem.files.grep(/^exe/) { |f| File.basename(f) }
  gem.require_paths = %w[lib]

  gem.required_ruby_version = '>= 2.4.2'

  gem.add_development_dependency 'bundler', '~> 2.0', '>= 2.0.2'
  gem.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
end
