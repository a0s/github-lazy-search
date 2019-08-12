task :environment do
  require File.expand_path(File.join(__FILE__, %w(.. config environment)))
end

task console: :environment do
  require 'pry'
  require 'awesome_print'
  Pry.config.quiet = true
  AwesomePrint.pry!
  binding.pry
end

task c: :console
