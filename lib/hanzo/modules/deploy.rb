module Hanzo
  module Deploy

    def self.init_cli(args)
      opts = OptionParser.new

      opts.banner = "Usage: hanzo deploy [options]"
      opts.on('-h', '--help', "This help") { puts opts }

      self.deploy(opts, args)

      opts
    end

    private

      def self.deploy(opts, args)
        branch = ask "-----> Branch to deploy in #{args[0]} [HEAD]: "

        `git push -f #{args[1]} #{branch}:master`
      end

  end
end
