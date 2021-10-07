module Hanzo
  module Installers
    module Remotes
      def install_remotes
        Hanzo.title 'Creating git remotes'

        Hanzo::Installers::Remotes.environments.each_pair do |env, app|
          Hanzo::Installers::Remotes.add_remote(app, env)
        end
      end

      def self.add_remote(app, env)
        Hanzo.print "Adding #{env}"
        Hanzo.run "git remote rm #{env} 2>&1 > /dev/null"
        Hanzo.run "git remote add #{env} https://git.heroku.com/#{app}.git"
      end

      def self.environments
        Hanzo.config['remotes']
      end

      def self.installed_environments
        `git remote`.split("\n")
      end
    end
  end
end
