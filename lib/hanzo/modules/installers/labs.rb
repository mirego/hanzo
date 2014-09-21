module Hanzo
  module Installers
    module Labs
      def install_labs
        Hanzo.title('Activating Heroku Labs')

        Hanzo::Heroku.available_labs.each do |name, _|
          next unless Hanzo.agree("Add #{name}?")

          Hanzo::Installers::Remotes.environments.each_pair do |env, _|
            Hanzo::Installers::Labs.enable(env, name)
          end
        end
      end

      def self.enable(env, lab)
        Hanzo.run "heroku labs:enable #{lab} --remote #{env}"
        Hanzo.print "- Enabled for #{env}"
      end
    end
  end
end
