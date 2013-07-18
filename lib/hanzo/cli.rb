module Hanzo

 class CLI

    attr_reader :options

    def initialize(arguments, stdin)
      @arguments = arguments
      @stdin = stdin

      app = (@arguments[0] =~ /-/) ? nil : @arguments[0]
      @opts = init_options(app)
    end

    def run
      begin
        @opts.parse!(@arguments)
      rescue Exception => e
        puts e
      end
    end

    protected

      def init_options(app=nil)
        opts = OptionParser.new

        # Extend CLI with modules
        if app.nil?
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
          opts = Hanzo.const_get(app.capitalize).init_cli(@arguments)
        end

        opts
      end

  end

end
