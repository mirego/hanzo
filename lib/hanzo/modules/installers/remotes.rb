module Hanzo
  module Installers
    module Remotes
      def install_remotes
        puts '-----> Creating git remotes'

        Hanzo::Installers::Remotes.environments.each_pair do |env, app|
          Hanzo::Installers::Remotes.add_remote(app, env)
        end
      end

      def self.add_remote(app, env)
        puts "       Adding #{env}"
        `git remote rm #{env} 2>&1 > /dev/null`
        `git remote add #{env} git@heroku.com:#{app}.git`
      end

      def self.environments
        return YAML.load_file('.heroku-remotes') if File.exists?('.heroku-remotes')

        puts '       Can\'t locate .heroku-remotes'
        puts '       For more information, please read https://github.com/mirego/hanzo'
        exit
      end
    end
  end
end
