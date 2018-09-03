# Installers
require_relative 'installers/remotes'

module Hanzo
  class Install < Base
    # Mixins
    include Hanzo::Installers::Remotes

  protected

    def initialize_variables
      @type = extract_argument(1)
    end

    def initialize_cli
      initialize_help && return if @type.nil?

      method = "install_#{@type}"

      if respond_to?(method)
        send(method)
      else
        initialize_help
      end
    end

    def initialize_help
      @options.banner = <<-BANNER.unindent
        Usage: hanzo install TYPE

        Available install type:
          remotes - Add git remotes to current repository
      BANNER
    end
  end
end
