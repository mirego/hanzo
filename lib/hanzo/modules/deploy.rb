module Hanzo
  class Deploy < Base

  protected

    def initialize_variables
      @env = extract_argument(1)
    end

    def initialize_cli
      initialize_help and return if @env.nil?

      deploy
      run_migrations
    end

    def initialize_help
      @options.banner = "Usage: hanzo deploy ENVIRONMENT"
    end

    def deploy
      branch = ask("-----> Branch to deploy in #{@env}: ") { |q| q.default = "HEAD" }

      `git push -f #{@env} #{branch}:master`
    end

    def run_migrations
      if Dir.exists?('db/migrate')
        migration = agree("-----> Run migrations? ")
        `heroku run rake db:migrate --remote #{@env}` if migration
      end
    end
  end
end
