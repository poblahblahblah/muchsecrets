Gem::Specification.new do |s|
  s.name        = "muchsecrets"
  s.version     = '0.0.5'
  s.date        = '2015-03-13'
  s.authors     = ["Pat O'Brien"]
  s.email       = ["muchsecrets@tetrisbocks.net"]
  s.description = "handles encrypting and decrypting secrets to/from consul."
  s.summary     = "much secrets, such security"
  s.homepage    = "http://github.com/poblahblahblah/muchsecrets"
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.executables << 'muchsecrets'
  s.license     = 'MIT'
end

