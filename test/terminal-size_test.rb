require './test/test_helper'
require 'terminal-size'
class TerminalTest < MiniTest::Unit::TestCase
  DEFAULT_SIZE = {:width => 80, :height => 25}
  def test_simulating_windows
    class << $stdout
      alias_method :actual_respond_to?, :respond_to?
    end
    brb_path = ENV['PATH']
    fake_respond_to = lambda {|m| :ioctl != m and actual_respond_to m }
    $stdin.stub :respond_to?, fake_respond_to do
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
    expected = {:width => 133, :height => 80}
    fake_ioctl = lambda {|num, buf| buf.replace FAKE_IOCTL_RESULT; 0 }
    $stdout.stub :ioctl, fake_ioctl do
      assert_equal expected, Terminal.size_via_low_level_ioctl
    end
    Terminal.stub :`, '80 133' do
      assert_equal expected, Terminal.size_via_stty
    end
  end

  def test_integration_using_tmux
    return warn "\nSKIP: integration test requires tmux" unless ENV['TMUX']
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
