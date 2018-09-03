module Hanzo
  module Heroku
    module Installers
      module Remotes
        # Constants
        HEROKU_DEFAULT_HOST = 'git@heroku.com'.freeze

        def self.host
          HEROKU_DEFAULT_HOST
        end

        def self.host_with_app(app)
          "#{HEROKU_DEFAULT_HOST}:#{app}.git"
        end
      end
    end
  end
end
