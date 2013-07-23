module Hanzo
  class Deploy < Base

  protected

    def initialize_variables
      @env = extract_argument(1)
    end

    def initialize_cli
      initialize_help and return if @env.nil?

      deploy
    end

    def initialize_help
      @options.banner = "Usage: hanzo deploy ENVIRONMENT"
    end

    def deploy
      branch = ask("-----> Branch to deploy in #{@env}: ") { |q| q.default = "HEAD" }

      `git push -f #{@env} #{branch}:master`

      migration = agree("-----> Run migrations? ")
      `bundle exec heroku run rake db:migrate --remote #{@env}` if migration
    end

  end
end
