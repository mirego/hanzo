module Hanzo
  class Deploy < Base
    # Classes
    UnknownEnvironment = Class.new(StandardError)
    UninstalledEnvironment = Class.new(StandardError)

    # Constants
    MIGRATION_COMMANDS = {
      'db/migrate' => 'rake db:migrate',
      'priv/repo/migrations' => 'mix ecto.migrate'
    }

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
      return if migration_directory.nil?
      return unless Hanzo.agree('Run database migrations?')

      Hanzo.run "heroku run #{migration_command} --remote #{@env}"
      Hanzo.run "heroku ps:restart --remote #{@env}"
    end

    def validate_environment_existence!
      raise UnknownEnvironment unless fetcher.exist?
      raise UninstalledEnvironment unless fetcher.installed?
    end

    def fetcher
      @fetcher ||= Hanzo::Fetchers::Environment.new(@env)
    end

    def migration_directory
      MIGRATION_COMMANDS.keys.find { |directory| Dir.exist?(directory) }
    end

    def migration_command
      MIGRATION_COMMANDS[migration_directory]
    end
  end
end
