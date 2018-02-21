module Hanzo
  class Deploy < Base
    # Classes
    UnknownEnvironment = Class.new(StandardError)
    UninstalledEnvironment = Class.new(StandardError)

  protected

    def initialize_variables
      @env = extract_argument(1)
      @env ||= Hanzo::Installers::Remotes.environments.keys.first
      @branch = extract_argument(2)
    end

    def initialize_cli
      initialize_help && return if @env.nil?

      deploy && run_after_deploy_commands
    rescue UnknownEnvironment
      Hanzo.unindent_print "Environment `#{@env}` doesn't exist. Add it to .hanzo.yml and run:\n  hanzo install remotes", :red
      Hanzo.unindent_print "\nFor more information, read https://github.com/mirego/hanzo#remotes", :red
    rescue UninstalledEnvironment
      Hanzo.unindent_print "Environment `#{@env}` has been found in your .hanzo.yml file. Before using it, you must install it:\n  hanzo install remotes", :red
    end

    def initialize_help
      @options.banner = <<-BANNER.unindent
        Usage: hanzo deploy ENVIRONMENT

        Available environments
      BANNER

      Hanzo::Installers::Remotes.environments.each do |env|
        @options.banner << "  - #{env.first}\n"
      end
    end

    def deploy
      validate_environment_existence!

      branch = @branch || Hanzo.ask("Branch to deploy in #{@env}:") { |q| q.default = 'HEAD' }

      Hanzo.run "git push -f #{@env} #{branch}:master"
    end

    def run_after_deploy_commands
      return unless after_deploy_commands.any?

      restart_needed = false

      after_deploy_commands.each do |command|
        next unless Hanzo.agree("Run `#{command}` on #{@env}?")
        Hanzo.run "heroku run #{command} --remote #{@env}"
        restart_needed = true
      end

      Hanzo.run "heroku ps:restart --remote #{@env}" if restart_needed
    end

    def after_deploy_commands
      Hanzo.config['after_deploy'] || []
    end

    def validate_environment_existence!
      raise UnknownEnvironment unless fetcher.exist?
      raise UninstalledEnvironment unless fetcher.installed?
    end

    def fetcher
      @fetcher ||= Hanzo::Fetchers::Environment.new(@env)
    end
  end
end
