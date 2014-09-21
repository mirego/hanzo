module Hanzo
  class Deploy < Base
  protected

    def initialize_variables
      @env = extract_argument(1)
      @env ||= Hanzo::Installers::Remotes.environments.keys.first
    end

    def initialize_cli
      initialize_help && return if @env.nil?

      deploy
      run_migrations
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
      branch = Hanzo.ask("Branch to deploy in #{@env}:") { |q| q.default = 'HEAD' }

      Hanzo.run "git push -f #{@env} #{branch}:master"
    end

    def run_migrations
      return unless Dir.exist?('db/migrate')
      return unless Hanzo.agree('Run migrations?')

      Hanzo.run "heroku run rake db:migrate --remote #{@env}"
      Hanzo.run "heroku ps:restart --remote #{@env}"
    end
  end
end
