require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files= FileList['test/test*.rb']
  t.verbose = true
end
