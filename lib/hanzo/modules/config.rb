module Hanzo
  class Config < Base
    def compare
      Hanzo.title('Fetching environment variables')
      fetch_variables

      Hanzo.title('Comparing environment variables')
      compare_variables
    end

  protected

    def initialize_variables
      @type = extract_argument(1)
    end

    def initialize_cli
      initialize_help && return if @type != 'compare'

      compare
    end

    def initialize_help
      @options.banner = <<-BANNER.unindent
        Usage: hanzo config TYPE

        Available install type:
          compare - Compare the environment variables set across the remotes
      BANNER
    end

  private

    def fetch_variables
      @variables = Hanzo::Installers::Remotes.environments.keys.reduce({}) do |memo, env|
        # Fetch the variables over at Heroku
        config = Hanzo.run("heroku config -r #{env}", true).split("\n")

        # Reject the first line (Heroku header)
        config = config.reject { |line| line =~ /^=/ }

        # Only keep the variable name, not their value
        config = config.map { |line| line.gsub(/^([^:]+):.*$/, '\1') }

        memo.merge env => config
      end
    end

    def compare_variables
      all_variables = @variables.values.flatten.uniq

      @variables.each_pair do |env, variables|
        missing_variables = all_variables - variables
        Hanzo.print "Missing variables in #{env}", :yellow
        Hanzo.print(missing_variables.map { |v| "- #{v}" })
      end
    end
  end
end
