require 'hanzo/modules/deploy'
require 'hanzo/modules/install'

module Hanzo

 class CLI

    def initialize(args)
      @args = args

      @app = (@args[0] =~ /-/) ? nil : @args[0]
      @opts = init_cli
    end

    def run
      @opts.parse!(@args) if @opts.respond_to? :parse!
      puts @opts unless @opts.nil?
    end

    protected

      def init_cli
        if @app.nil?
          opts = OptionParser.new
          opts.banner = <<-BANNER
Usage: hanzo action [options]

Available actions:
   deploy — Deploy a branch or a tag
  install — Install Hanzo configuration

Options:
BANNER
          opts.on('-h', '--help', 'You\'re looking at it.') { puts opts }
          opts.on('-v', '--version', 'Print version') { puts "Hanzo #{Hanzo::VERSION}" }
        else
          opts = Hanzo.const_get(@app.capitalize).new(@args).options
        end

        opts
      end

  end

end
