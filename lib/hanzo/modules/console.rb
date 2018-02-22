module Hanzo
  class Console < Base
    # Classes
    UnknownEnvironment = Class.new(StandardError)
    UninstalledEnvironment = Class.new(StandardError)
    UnknownCommand = Class.new(StandardError)

    def initialize_variables
      @env = extract_argument(1)
    end

    def initialize_cli
      initialize_help && return if @env.nil?

      validate_environment_existence!

      console
    rescue UnknownCommand
      Hanzo.unindent_print 'A “console” command is needed in `.hanzo.yml`', :red
    rescue UnknownEnvironment
      Hanzo.unindent_print "Environment `#{@env}` doesn't exist. Add it to .hanzo.yml and run:\n  hanzo install remotes", :red
      Hanzo.unindent_print "\nFor more information, read https://github.com/mirego/hanzo#remotes", :red
    rescue UninstalledEnvironment
      Hanzo.unindent_print "Environment `#{@env}` has been found in your .hanzo.yml file. Before using it, you must install it:\n  hanzo install remotes", :red
    end

    def console
      command = Hanzo.config['console']
      raise UnknownCommand unless command

      Hanzo.run "heroku run --remote #{@env} #{command}"
    end

  protected

    def initialize_help
      @options.banner = <<-BANNER.unindent
        Usage: hanzo console ENVIRONMENT

        Available environments
      BANNER

      Hanzo::Installers::Remotes.environments.each do |env|
        @options.banner << "  - #{env.first}\n"
      end
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
