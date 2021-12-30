#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/clean'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end