module Hanzo
  class Diff < Base
    # Classes
    UnknownEnvironment = Class.new(StandardError)
    UninstalledEnvironment = Class.new(StandardError)

  protected

    def initialize_variables
      @env = extract_argument(1)
      @env ||= Hanzo::Installers::Remotes.environments.keys.first
    end

    def initialize_cli
      return false if @env.nil?

      diff

      true
    rescue UnknownEnvironment
      Hanzo.unindent_print "Environment `#{@env}` doesn't exist. Add it to .hanzo.yml and run:\n  hanzo install remotes", :red
      Hanzo.unindent_print "\nFor more information, read https://github.com/mirego/hanzo#install-remotes", :red
    rescue UninstalledEnvironment
      Hanzo.unindent_print "Environment `#{@env}` has been found in your .hanzo.yml file. Before using it, you must install it:\n  hanzo install remotes", :red
    end

    def initialize_help
      @options.banner = <<-BANNER.unindent
        Usage: hanzo diff ENVIRONMENT

        Available environments
      BANNER

      Hanzo::Installers::Remotes.environments.each do |env|
        @options.banner << "  - #{env.first}\n"
      end
    end

    def diff
      validate_environment_existence!
      Hanzo.run("git remote update #{@env} && git diff #{@env}/master...HEAD")
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
