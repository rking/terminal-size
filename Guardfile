# More info at https://github.com/guard/guard#readme

# These reboot spork completely
guard 'spork',
  minitest: true,
  test_unit: false,

  # Four lines of Rails stuff:
  minitest_unit_env: { 'RAILS_ENV' => 'test' } do
  watch %r{config/(?:application|environment(?:s/test)?).rb}
  watch %r{^config/initializers/.+\.rb$}
  watch /Gemfile(?:\.lock)?/

  watch 'test/test_helper.rb' do :minitest end
end

guard 'minitest', all_on_start: true, drb: true do
  # Minitest::Unit style test files
  watch %r|^test/.*_test\.rb|
  watch %r|^lib/(.*)\.rb| do |m| "test/#{m[1]}_test.rb" end
  watch %r|^test/test_helper\.rb| do 'test' end

  # Rails app/ dir mapping directly parallel to test/* dirs.
  #   (Assumes all test/* dir names are the same as the dirs in app/*
  #    Will need adjustment if you use app/controllers ⇒ test/functional, etc.)
  watch %r|^app/(.*)\.rb| do |m| "test/#{m[1]}_test.rb" end
end
# vim:ft=ruby
