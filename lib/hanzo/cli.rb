module Hanzo
  class CLI < Base
    def run
      @options.parse!(@args) if @options.respond_to?(:parse!)
    end

  protected

    def initialize_variables
      @app = extract_argument(0)
    end

    def initialize_options
      @options.on('-h', '--help', 'You\'re looking at it.') { puts @options }
      @options.on('-v', '--version', 'Print version') { puts "Hanzo #{Hanzo::VERSION}" }
    end

    def initialize_cli
      return true if /^-/.match?(@app)
      return false if @app.nil?

      begin
        @options = Hanzo.const_get(@app.capitalize).new(@args).options
      rescue NameError
        return false
      ensure
        true
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
    end
  end
end
