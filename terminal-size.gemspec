# -*- encoding: utf-8 -*-
$:.unshift './lib'
require 'terminal-size'

Gem::Specification.new do |gem|
  gem.name          = 'terminal-size'
  gem.version       = Terminal::Size::VERSION
  gem.authors       = %w(☈king Norrin)
  gem.email         = ['rking-terminal-size@sharpsaw.org']
  gem.description   = gem.summary = %q{Terminal.size ⇒ {columns: 80, rows: 25}}
  gem.homepage      = 'https://github.com/rking/terminal-size'
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
end
