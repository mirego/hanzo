module Hanzo
  class Install
    module Remotes

      def install_remotes
        puts '-----> Creating git remotes'

        if File.exists?('.heroku-remotes')
          envs = YAML.load_file('.heroku-remotes')

          envs.each_pair do |env, app|
            puts "       Adding #{env}"
            `git remote rm #{env} 2>&1 > /dev/null`
            `git remote add #{env} git@heroku.com:#{app}.git`
          end
        else
          puts '       Can\'t locate .heroku-remotes'
          puts '       For more information, please read https://github.com/mirego/hanzo'
        end
      end

    end
  end
end
