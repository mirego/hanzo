# Installers
require 'hanzo/modules/installers/remotes'
require 'hanzo/dokku/installers/remotes'
require 'hanzo/heroku/installers/remotes'

module Hanzo
  module Installers
    module Remotes
      def install_remotes
        Hanzo.title('Creating git remotes')

        Hanzo::Installers::Remotes.environments.each_pair do |env, app|
          Hanzo::Installers::Remotes.add_remote(app, env)
        end
      end

      def self.add_remote(app, env)
        Hanzo.print("Adding #{env}")
        Hanzo.run("git remote rm #{env} &> /dev/null")
        Hanzo.run("git remote add #{env} #{Hanzo::Installers::Remotes.host_with_app(app)}")
      end

      def self.environments
        Hanzo.config['remotes']
      end

      def self.installed_environments
        `git remote`.split("\n")
      end

      def self.host_with_app(app)
        Object.const_get("Hanzo::#{Hanzo.config['provider'].capitalize}::Installers::Remotes").host_with_app(app)
      end
    end
  end
end
