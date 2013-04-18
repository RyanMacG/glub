# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "glub"
  gem.homepage = "http://georgemcintosh.com/glub"
  gem.license = "Apache 2.0"
  gem.summary = "Command-line Gitlab client" 
  gem.description = "Glub - a Gitlab client for your command-line." 
  gem.email = "george@georgemcintosh.com"
  gem.authors = ["George McIntosh"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*.rb'
  test.verbose = true
end

task :default => :test

