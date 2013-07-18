require 'hanzo/modules/install/remotes'

module Hanzo
  class Install

    include Hanzo::Install::Remotes

    attr_accessor :options

    def initialize(args)
      @args = args
      @type = (@args[1] =~ /-/) ? nil : @args[1]

      init_cli
    end

    protected

      def init_cli
        opts = OptionParser.new

        if @type.nil?
          opts.banner = <<-BANNER
Usage: hanzo install TYPE

Available install type:
  remotes — Add git remotes to current repository
BANNER
        else
          send("install_#{@type}")
          opts = nil
        end

        @options = opts
      end

  end
end
