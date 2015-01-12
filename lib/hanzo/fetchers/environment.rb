module Hanzo
  module Fetchers
    class Environment
      def initialize(env)
        @env = env
      end

      def exist?
        environments.include?(@env)
      end

      def installed?
        installed_environments.include?(@env)
      end

    protected

      def installed_environments
        Hanzo::Installers::Remotes.installed_environments
      end

      def environments
        Hanzo::Installers::Remotes.environments
      end
    end
  end
end
