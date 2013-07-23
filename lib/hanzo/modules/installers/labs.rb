module Hanzo
  module Installers
    module Labs

      def install_labs
        puts '-----> Activating Heroku Labs'

        ['preboot', 'user-env-compile'].each do |lab|
          if agree("       Add #{lab}? ")
            Hanzo::Installers::Remotes.environments.each_pair do |env, app|
              Hanzo::Installers::Labs.enable(env, lab)
            end
          end
        end
      end

      def self.enable(env, lab)
        `bundle exec heroku labs:enable #{lab} --remote #{env}`
        puts "       - Enabled for #{env}"
      end

    end
  end
end
