require 'hanzo/modules/deploy'

module Hanzo

 class CLI

    def initialize(args)
      @args = args

      @app = (@args[0] =~ /-/) ? nil : @args[0]
      @opts = init_cli
    end

    def run
      @opts.parse!(@args)
    end

    protected

      def init_cli
        opts = OptionParser.new

        # Extend CLI with modules
        if @app.nil?
          opts.banner = <<-BANNER
Usage: hanzo action [options]

Available actions:
   deploy — Deploy a branch or a tag
  install — Install Heroku remotes to your local git/config

Options:
BANNER
          opts.on('-h', '--help', 'You\'re looking at it.'){ puts opts }
          opts.on('-v',  '--version',  'Print version'){ puts "Hanzo #{Hanzo::VERSION}" }
        else
          opts = Hanzo.const_get(@app.capitalize).new(@args)
        end

        opts
      end

  end

end
