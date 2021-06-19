
Gem::Specification.new do |s|
  s.name = 'fresh_jwt'
  s.version = '0.0.1'
  s.summary = 'Fresh JWT token!'
  s.description = 'Issue access JWT & secure with refresh token'
  s.authors = ["Andrei Mosin"]
  s.email = 'otmosina@gmail.com'
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files = s.files.grep(/^spec/)
  s.homepage = 'https://rubygems.org/gems/fresh_jwt'
  s.license = 'MIT'
end