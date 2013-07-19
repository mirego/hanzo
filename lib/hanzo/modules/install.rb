require 'hanzo/modules/installers/remotes'

module Hanzo
  class Install < Base

    include Hanzo::Installers::Remotes

    def initialize(args)
      @type = (args[1] =~ /-/) ? nil : args[1]
      super
    end

  protected

    def initialize_cli
      initialize_help and return if @type.nil?

      send "install_#{@type}"
    end

    def initialize_help
      @options.banner = <<-BANNER
Usage: hanzo install TYPE

Available install type:
  remotes — Add git remotes to current repository
BANNER
    end

  end
end
