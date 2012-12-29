require 'bundler/gem_tasks'
# TODO: require 'working/rake'
task default: :test
task :test do
  Dir['test/**/*_test.rb'].each do |e| load e end
end
