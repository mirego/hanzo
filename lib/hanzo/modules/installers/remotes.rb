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
        Hanzo.run "git remote add #{env} git@heroku.com:#{app}.git"
      end

      def self.environments
        return YAML.load_file('.heroku-remotes') if File.exists?('.heroku-remotes')

        Hanzo.print 'Cannot locate .heroku-remotes'
        Hanzo.print 'For more information, please read https://github.com/mirego/hanzo'
        exit
      end
    end
  end
end
