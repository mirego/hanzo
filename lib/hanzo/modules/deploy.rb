module Hanzo
  class Deploy < Base

    def initialize(args)
      @env = (args[1] =~ /-/) ? nil : args[1]
      super
    end

    protected

      def init_cli
        init_help and return if @env.nil?

        deploy
      end

      def init_help
        @options.banner = "Usage: hanzo deploy ENVIRONMENT"
      end

      def deploy
        branch = ask("-----> Branch to deploy in #{@env}: ") { |q| q.default = "HEAD" }

        `git push -f #{@env} #{branch}:master`
      end

  end
end
