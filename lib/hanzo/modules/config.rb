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
      return false if @type != 'compare'

      compare

      true
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
        memo.merge(env => Object.const_get("Hanzo::#{Hanzo.config['provider'].capitalize}").fetch_config(env))
      end
    end

    def compare_variables
      all_variables = @variables.values.flatten.uniq
      has_missing_variables = false

      @variables.each_pair do |env, variables|
        missing_variables = all_variables - variables

        next if missing_variables.empty?

        has_missing_variables = true

        Hanzo.print("Missing variables in #{env}", :yellow)
        Hanzo.print(missing_variables.map { |v| "- #{v}" })
      end

      Hanzo.print('No missing variables', :yellow)
    end
  end
end
