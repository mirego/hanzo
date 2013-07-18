module Hanzo
  class Deploy

    attr_accessor :options

    def initialize(args)
      @args = args
      @env = (@args[1] =~ /-/) ? nil : @args[1]

      init_cli
    end

    protected

      def init_cli
        opts = OptionParser.new

        if @env.nil?
          opts.banner = "Usage: hanzo deploy ENVIRONMENT\n\n"
          opts.on('-h', '--help', 'This help') { puts opts }
        else
          deploy
        end

        @options = opts
      end

      def deploy
        branch = ask("-----> Branch to deploy in #{@env}: ") { |q| q.default = "HEAD" }

        `git push -f #{@env} #{branch}:master`
      end

  end
end
