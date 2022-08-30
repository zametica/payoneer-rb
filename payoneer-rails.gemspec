require File.expand_path('lib/payoneer/version', __dir__)

Gem::Specification.new do |s|
  s.name          = 'payoneer-rails'
  s.version       = Payoneer::VERSION
  s.platform      = Gem::Platform::RUBY
  s.license       = 'MIT'
  s.authors       = ['Amir Zametica']
  s.email         = ['amirzametica@gmail.com']
  s.description   = 'This library provides integration with Payoneer V4 API'
  s.summary       = 'Payoneer V4 integration with Rails'
  s.homepage      = 'https://github.com/zametica/payoneer-rails'

  s.files         =  Dir.glob('{lib, spec}/**/*')
  s.files         += %w[CHANGELOG.md LICENSE README.md]
  s.files         += %w[Rakefile payoneer-rails.gemspec]

  s.require_path = 'lib'

  s.add_dependency 'httparty', '~> 0.20', '>= 0.20.0'

  s.add_development_dependency 'bundler', '~> 2.3.0'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rails', '~> 5.0'
  s.add_development_dependency 'rspec-rails', '~> 5.1.0'
  s.add_development_dependency 'pry', '~> 0.14.0'
end
