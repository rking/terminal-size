# -*- encoding: utf-8 -*-
require 'working/gemspec'
require 'terminal-size'

Working.gemspec(
  :name => 'terminal-size',
  :summary => Working.third_line_of_readme,
  :description => Working.readme_snippet(/== Usage/, /== Bonus Contract/),
  :version => Terminal::Size::VERSION,
  :authors => %w(☈king Norrin),
  :email => 'rking-terminal-size@sharpsaw.org',
  :github => 'rking/terminal-size',
  :deps => []
)
