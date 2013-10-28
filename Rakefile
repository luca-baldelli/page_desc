Bundler.require :development

RSpec::Core::RakeTask.new(:specs) do
  ENV['coverage'] = 'true'
end

task :default => [:specs]