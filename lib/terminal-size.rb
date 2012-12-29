class Terminal
  class Size; VERSION = '0.0.1' end
  class << self
    def size
      size_via_low_level_ioctl or size_via_stty or nil
    end
    def size!; size or _width_height_hash_from 80, 25 end

    # These are experimental
    def resize direction, magnitude
      tmux 'resize-pane', "-#{direction}", magnitude
    end

    def tmux *cmd
      system 'tmux', *(cmd.map &:to_s)
    end

    IOCTL_INPUT_BUF = "\x00"*8
    def size_via_low_level_ioctl
      # Thanks to runpaint for the general approach to this
      return unless $stdin.respond_to? :ioctl
      code = tiocgwinsz_value_for RUBY_PLATFORM
      return unless code
      buf = IOCTL_INPUT_BUF.dup
      return unless $stdout.ioctl(code, buf).zero?
      return if IOCTL_INPUT_BUF == buf
      got = buf.unpack('S4')[0..1]
      _width_height_hash_from *got
    rescue
      nil
    end

    # This is as reported by <sys/ioctl.h>
    # Hard-coding because it seems like overkll to acutally involve C for this.
    TIOCGWINSZ = {
      /linux/ => 0x5413,
      /darwin/ => 0x40087468, # thanks to brandon@brandon.io for the lookup!
    }
    def tiocgwinsz_value_for platform
      TIOCGWINSZ.each do |k,v|
        return v if platform[k]
      end
      nil
    end

    def size_via_stty
      ints = `stty size`.scan(/\d+/).map &:to_i
      _width_height_hash_from ints[1], ints[0]
    rescue
      nil
    end

    private
    def _width_height_hash_from *dimensions
      { width: dimensions[0], height: dimensions[1] }
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
