module Hanzo
  module Dokku
    module Installers
      module Remotes
        def self.host
          Hanzo.config['host']
        end

        def self.host_with_app(app)
          "#{Hanzo.config['host']}:#{app}"
        end
      end
    end
  end
end
