require 'rake/testtask'

#task :default => [:test]

#task :test do
#  ruby "test/glub.rb"
#end 

Rake::TestTask.new do |t|
  t.libs = ["lib"]
  t.warning = true
  t.verbose = true
  t.test_files = FileList['test/*.rb']
end
