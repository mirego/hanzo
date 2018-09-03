module Hanzo
  module Dokku
    def self.run_command(env, command)
      Hanzo.run("ssh -t #{Hanzo.config['host']} run #{Hanzo.config['remotes'][env]} #{command}")
    end

    def self.restart_app(env)
      Hanzo.run("ssh -t #{Hanzo.config['host']} ps:restart #{Hanzo.config['remotes'][env]}")
    end

    def self.fetch_config(env)
      config = Hanzo.run("ssh -t #{Hanzo.config['host']} config #{Hanzo.config['remotes'][env]}", true).split("\n")

      # Reject the first line
      config = config.reject { |line| line =~ /^=/ }

      # Only keep the variable name, not their value
      config.map { |line| line.gsub(/^([^:]+):.*$/, '\1') }
    end
  end
end
