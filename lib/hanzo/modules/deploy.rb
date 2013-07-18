module Hanzo
  class Deploy

    def initialize(args)
      @args = args

      @env = (@args[0] =~ /-/) ? nil : @args[0]
      @opts = init_cli
    end

    protected

      def init_cli
        opts = OptionParser.new

        if @env.nil?
          opts.banner = "Usage: hanzo deploy ENVIRONMENT"
          opts.on('-h', '--help', "This help") { puts opts }
        else
          deploy
        end

        opts
      end

      def deploy
        branch = ask "-----> Branch to deploy in #{@env} [HEAD]: "

        `git push -f #{@env} #{branch}:master`
      end

  end
end
