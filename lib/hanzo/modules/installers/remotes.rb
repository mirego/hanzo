module Hanzo
  module Installers
    module Remotes

      def install_remotes
        puts '-----> Creating git remotes'

        if File.exists?('.heroku-remotes')
          envs = YAML.load_file('.heroku-remotes')

          envs.each_pair do |env, app|
            Hanzo::Installers::Remotes.add_remote(app, env)
          end
        else
          puts '       Can\'t locate .heroku-remotes'
          puts '       For more information, please read https://github.com/mirego/hanzo'
        end
      end

      def self.add_remote(app, env)
        puts "       Adding #{env}"
        `git remote rm #{env} 2>&1 > /dev/null`
        `git remote add #{env} git@heroku.com:#{app}.git`
      end

    end
  end
end
