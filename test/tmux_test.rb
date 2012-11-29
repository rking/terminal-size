require 'test_helper'
require 'terminal-size'
class TerminalTest < MiniTest::Unit::TestCase
  def test_resize
    skip 'Must be run from within tmux' unless ENV['TMUX']
    # TODO: figure out how to get this to work if not already in a horizontal
    # split, e.g.:
    # system 'tmux split-window -h'
    # Or maybe: tmux list-panes
    before = Terminal.size
    Terminal.resize :L, 1
    after = Terminal.size
    assert_equal before[:width]-1, after[:width]
  ensure
    Terminal.resize :R, 1
  end
end
