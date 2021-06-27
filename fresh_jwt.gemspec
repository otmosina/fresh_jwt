
Gem::Specification.new do |s|
  s.name = 'fresh_jwt'
  s.version = '0.0.2'
  s.summary = 'Fresh JWT token!'
  s.description = 'Issue access JWT & secure with refresh token'
  s.authors = ["Andrei Mosin"]
  s.email = 'otmosina@gmail.com'
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files = s.files.grep(/^spec/)
  s.homepage = 'https://rubygems.org/gems/fresh_jwt'
  s.license = 'MIT'

  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.7.3'

  s.add_runtime_dependency 'jwt', '~> 2.2.3'
  s.add_runtime_dependency 'dry-initializer', '~> 3.0'
  s.add_runtime_dependency 'dry-monads', '~> 1.3'
  s.add_runtime_dependency 'dry-validation', '~> 1.6'

  s.add_development_dependency 'pry', '~> 0.14'
  s.add_development_dependency 'rspec', '~> 3.10'
  s.add_development_dependency 'simplecov', '~> 0.22'
  s.add_development_dependency 'timecop', '~> 0.9'

end