require 'test_helper'
require 'terminal-size'
class TerminalTest < MiniTest::Unit::TestCase
  DEFAULT_SIZE = {width: 80, height: 25}
  def test_simulating_windows
    class << $stdout
      alias_method :actual_respond_to?, :respond_to?
    end
    brb_path = ENV['PATH']
    $stdout.stub :respond_to?, -> m { :ioctl != m and actual_respond_to m } do
      refute Terminal.size_via_low_level_ioctl
      ENV['PATH'] = ''
      refute Terminal.size_via_stty
      refute Terminal.size
      assert_equal DEFAULT_SIZE, Terminal.size!
    end
  ensure
    ENV['PATH'] = brb_path
  end

  # This junky thing is an in-real-life result of a TIOCGWINSZ call
  FAKE_IOCTL_RESULT = File.read 'test/real-life-ioctl-return-value'
  def test_ioctl_for_unix
    refute_equal \
      Terminal.tiocgwinsz_value_for('linux'),
      Terminal.tiocgwinsz_value_for('darwin')
    $stdout.stub :ioctl, -> num, buf { buf.replace FAKE_IOCTL_RESULT; 0 } do
      expected = {width: 80, height: 133}
      assert_equal expected, Terminal.size_via_low_level_ioctl
    end
  end

  def test_integration_using_tmux
    skip 'Must be run from within tmux' unless ENV['TMUX']
    # TODO: figure out how to get this to work if not already in a horizontal
    # split, e.g.:
    # system 'tmux split-window -h'
    # Or maybe: tmux list-panes
    before = Terminal.size
    Terminal.resize :L, 1
    after = Terminal.size
    assert_equal before[:width]-1, after[:width]
    assert_equal before[:width]-1, after[:width]
  ensure
    Terminal.resize :R, 1
  end
end
