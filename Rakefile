require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:tests) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation'
end

RSpec::Core::RakeTask.new(:original) do |t|
  t.pattern = Dir.glob('spec/models/car_rental_initial.rb')
  t.rspec_opts = '--format documentation'
end
