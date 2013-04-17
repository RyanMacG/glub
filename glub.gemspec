Gem::Specification.new do |s|
  s.name        = 'glub'
  s.version     = '0.0.2'
  s.date        = '2013-04-17'
  s.description = 'A command-line client for the Gitlab API'
  s.summary     = 'glub - Gitlab from your terminal'
  s.authors     = ['George McIntosh']
  s.email       = 'george@georgemcintosh.com'
  s.files       = ['lib/glub.rb']
  s.homepage    = 'https://github.com/georgecodes/glub'
  s.executables << 'glub'
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "rest-client"
end 
