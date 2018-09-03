module Hanzo
  module Heroku
    def self.run_command(env, command)
      Hanzo.run("heroku run --remote #{env} #{command}")
    end

    def self.restart_app(env)
      Hanzo.run("heroku ps:restart --remote #{env}")
    end

    def self.fetch_config(env)
      config = Hanzo.run("heroku config --remote #{env}", true).split("\n")

      # Reject the first line
      config = config.reject { |line| line =~ /^=/ }

      # Only keep the variable name, not their value
      config.map { |line| line.gsub(/^([^:]+):.*$/, '\1') }
    end
  end
end
