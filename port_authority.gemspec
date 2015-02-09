Gem::Specification.new do |s|
  s.name        = "port_authority"
  s.version     = '0'
  s.authors     = ["Josh Cheek"]
  s.email       = ["josh.cheek@gmail.com"]
  s.homepage    = "https://github.com/JoshCheek"
  s.summary     = %q{Npm style package management}
  s.description = %q{https://twitter.com/josh_cheek/status/564560602828242944 Yes, I am squatting. If I haven't done anything with this in like a year, and you want the name, let me know and I'll probably give it to you.}
  s.license     = "WTFPL"
  s.files       = `git ls-files`.split("\n") - ['docs/seeing is believing.psd']
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # s.require_paths = ["lib"]
end
