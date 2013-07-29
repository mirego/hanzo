module Hanzo
  module Installers
    module Labs
      def install_labs
        puts '-----> Activating Heroku Labs'

        Hanzo::Heroku.available_labs.each do |name, description|
          if agree("       Add #{name}? ")
            Hanzo::Installers::Remotes.environments.each_pair do |env, app|
              Hanzo::Installers::Labs.enable(env, lab)
            end
          end
        end
      end

      def self.enable(env, lab)
        `heroku labs:enable #{lab} --remote #{env}`
        puts "       - Enabled for #{env}"
      end
    end
  end
end
