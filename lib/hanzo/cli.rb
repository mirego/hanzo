require 'hanzo/modules/deploy'
require 'hanzo/modules/install'

module Hanzo
 class CLI < Base

    def initialize(args)
      @app = (args[0] =~ /-/) ? nil : args[0]
      super
    end

    def run
      @options.parse!(@args) if @opts.respond_to? :parse!
      puts @options unless @options.to_s == "Usage: hanzo [options]\n"
    end

  protected

    def initialize_cli
      initialize_help and return if @app.nil?

      @options = Hanzo.const_get(@app.capitalize).new(@args).options
    end

    def initialize_help
      @options.banner = <<-BANNER
Usage: hanzo action [options]

Available actions:
   deploy — Deploy a branch or a tag
  install — Install Hanzo configuration

Options:
BANNER
      @options.on('-h', '--help', 'You\'re looking at it.') { puts @options }
      @options.on('-v', '--version', 'Print version') { puts "Hanzo #{Hanzo::VERSION}" }
    end

  end
end
