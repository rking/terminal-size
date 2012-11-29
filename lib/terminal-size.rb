class Terminal
  class << self
    def size
      height, width = `stty size`.scan(/\d+/).map &:to_i
      return { height: height, width: width }
    end

    # These are experimental
    def resize direction, magnitude
      tmux 'resize-pane', "-#{direction}", magnitude
    end
    def tmux *cmd
      system 'tmux', *(cmd.map &:to_s)
    end
  end
end
__END__
# from highline
          if /solaris/ =~ RUBY_PLATFORM and
            `stty` =~ /\brows = (\d+).*\bcolumns = (\d+)/
            [$2, $1].map { |c| x.to_i }
# from hirb
      if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
        [ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
      elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) && command_exists?('tput')
        [`tput cols`.to_i, `tput lines`.to_i]
