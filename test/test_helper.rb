# If on Rails:
# ENV['RAILS_ENV'] = 'test'
# require File.expand_path('../../config/environment', __FILE_)
# def reload!
#   puts "[Performing .reload!]"
#   ActionDispatch::Reloader.cleanup!
#   ActionDispatch::Reloader.prepare!
# end

require 'spork'
require 'minitest/autorun'
require 'pry-rescue/minitest'
$:.unshift './lib'

require 'turn'
Turn.config do |c|
  c.format = :pretty
end

puts "[test_helper.rb toplevel running]"
Spork.prefork do
    puts "[Spork.prefork running]"
end
Spork.each_run do
  puts "[Spork.each_run running]"
  # TODO: verify that this helps (Rails)
  # reload!
end
