require 'hanzo/modules/deploy'
require 'hanzo/modules/diff'
require 'hanzo/modules/install'
require 'hanzo/modules/config'
require 'hanzo/modules/console'

module Hanzo
  class CLI < Base
    def run
      @options.parse!(@args) if @options.respond_to? :parse!
      puts @options unless @options.to_s == "Usage: hanzo [options]\n"
    end

  protected

    def initialize_variables
      @app = extract_argument(0)
    end

    def initialize_cli
      @options.on('-v', '--version', 'Print version') do
        puts "Hanzo #{Hanzo::VERSION}"
        exit
      end

      begin
        @options = Hanzo.const_get(@app.capitalize).new(@args).options
      rescue NameError
        initialize_help
      end
    end

    def initialize_help
      @options.banner = <<-BANNER.unindent
        Usage: hanzo action [options]

        Available actions:
           deploy - Deploy a branch or a tag
             diff - Show the diff between HEAD and the current release
          install - Install Hanzo configuration
           config - Manage Heroku configuration variables
          console - Run a console command

        Options:
      BANNER
      @options.on('-h', '--help', 'You\'re looking at it.')
    end
  end
end
