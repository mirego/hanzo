module Hanzo
  class Deploy < Base
    UnknownEnvironment = Class.new(StandardError)
    UninstalledEnvironment = Class.new(StandardError)

  protected

    def initialize_variables
      @env = extract_argument(1)
      @env ||= Hanzo::Installers::Remotes.environments.keys.first
    end

    def initialize_cli
      initialize_help && return if @env.nil?

      deploy && run_migrations
    rescue UnknownEnvironment
      Hanzo.unindent_print "Environment `#{@env}` doesn't exist. Add it to .heroku-remotes and run:\n  hanzo install remotes", :red
      Hanzo.unindent_print "\nFor more information, read https://github.com/mirego/hanzo#install-remotes", :red
    rescue UninstalledEnvironment
      Hanzo.unindent_print "Environment `#{@env}` has been found in your .heroku-remotes file. Before using it, you must install it:\n  hanzo install remotes", :red
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

      branch = Hanzo.ask("Branch to deploy in #{@env}:") { |q| q.default = 'HEAD' }

      Hanzo.run "git push -f #{@env} #{branch}:master"
    end

    def run_migrations
      return unless Dir.exist?('db/migrate')
      return unless Hanzo.agree('Run migrations?')

      Hanzo.run "heroku run rake db:migrate --remote #{@env}"
      Hanzo.run "heroku ps:restart --remote #{@env}"
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
